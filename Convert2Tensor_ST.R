#!/usr/bin/env Rscript

# Before running this script to generate tensor data, please make sure you have already 
# downloaded low resolution data from spatial research group
#
#       https://www.spatialresearch.org/resources-published-datasets/doi-10-1126science-aaf2403/
#
# Available tissues on spatial research group (3 replicates for Mouse Olfactory Bulb):
#
#       Rep1_MOB        Rep2_MOB        Rep3_MOB
#
#
# Count matrix data and spatial coordindates can be downloaded with following links (replace 
# "tissue-name" with one from above list)
#
#       Count matrix data and spatial coordinates: 
#       https://www.spatialresearch.org/wp-content/uploads/2016/07/<tissue-name>_count_matrix-1.tsv
#

# Package required to run this script
packages <- c("argparser", "Matrix", "R.matlab", "BiocManager")

# Install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}

# Install gene length database for normalization
BiocManager::install("geneLenDataBase")

# Load packages
invisible(lapply(packages, library, character.only = TRUE))
invisible(library(geneLenDataBase))

# Load gene length database
invisible(data("mm9.geneSymbol.LENGTH"))
invisible(data("hg19.geneSymbol.LENGTH"))

# arguments parser
p <- arg_parser("Convert spatial transcriptomics matrix data into tensor format")
p <- add_argument(p, "--input", help="Path to input folder", type="character")
p <- add_argument(p, "--output", help="Path to output folder", type="character")
p <- add_argument(p, "--human", help="human tissue", flag=TRUE)
argv <- parse_args(p)

# List all tissues for convertion
tissue_names = as.character(sapply(list.files(paste0(argv$input, "/"), pattern="*_count_matrix-1.tsv"), function(x) 
  paste(unlist(strsplit(x, "[_]"))[1:2], collapse = "_")))

for(tn in tissue_names){
  
  # Read count matrix data
  t = read.table(paste0(argv$input, "/", tn, "_MOB_count_matrix-1.tsv"))
  
  # Keep genes with length information
  if(!argv$human){
    gene_names = intersect(mm9.geneSymbol.LENGTH$Gene, colnames(t))
    geneLength = mm9.geneSymbol.LENGTH$Length[match(gene_names, mm9.geneSymbol.LENGTH$Gene)]
  }else{
    gene_names = intersect(hg19.geneSymbol.LENGTH$Gene, colnames(t))
    geneLength = hg19.geneSymbol.LENGTH$Length[match(gene_names, hg19.geneSymbol.LENGTH$Gene)]
  }
  
  # Remove spots without any gene expression
  t = t[,match(gene_names, colnames(t))]
  t = t[which(rowSums(t)!=0),]
  
  # Write gene names of tensor slice for each tissue to output folder
  fwrite(list(gene_names), paste0(argv$output, "/", tn, "_gene_names.csv"), sep="\n")
  
  # RPKM normalization
  t = apply(t, 1, function(x) 10^9 * x / geneLength / sum(x))
  t = t(log(t+1))
  
  # Parse spatial coordinates
  loc_info = sapply(rownames(t), function(x) unlist(strsplit(x, 'x')))
  loc_info = t(apply(loc_info, 2, function(x) round(as.numeric(x))))
  
  t = data.frame(x_coords=loc_info[,1], y_coords=loc_info[,2], t)
  t = melt(t, id=c("x_coords", "y_coords"))
  t$variable = as.numeric(t$variable)
  t = t[which(t$value!=0),]
  t = t[order(t$x_coords, t$y_coords), ]
  
  # Write tensor data to output folder
  writeMat(paste0(argv$output, "/", tn, "_count_matrix_rpkm.mat"), V = t, X=33, Y=35, Z=length(gene_names))
}