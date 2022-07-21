#!/usr/bin/env Rscript

# Before running this script to generate tensor data, please make sure you have already 
# downloaded Visium data from 10x genomics (Space Ranger v1.0.0):
#
#       https://support.10xgenomics.com/spatial-gene-expression/datasets/
#
# Under Visium Spatial for FFPE Demonstration (v1 Chemistry)/Visium Demonstration (v1 Chemistray)
# choose tab "Space Ranger v1.0.0"
# Available tissues on 10x genomics:
#
#       V1_Adult_Mouse_Brain                              V1_Breast_Cancer_Block_A_Section_1
#       V1_Breast_Cancer_Block_A_Section_2                V1_Human_Heart
#       V1_Human_Lymph_Node                               V1_Mouse_Brain_Sagittal_Anterior
#       V1_Mouse_Brain_Sagittal_Anterior_Section_2        V1_Mouse_Brain_Sagittal_Posterior
#       V1_Mouse_Brain_Sagittal_Posterior_Section_2       V1_Mouse_Kidney
#
#
# Note that we only use filtered feature-barcode matrix data and spatial coordindates, and they 
# can be downloaded with following links (replace "tissue-name" with one from above list)
#
#       filtered feature-barcode matrix data: 
#       https://cf.10xgenomics.com/spatial-gene-expression/datasets/<tissue-name>/<tissue-name>_filtered_feature_bc_matrix.tar.gz
#
#       spatial coordinates:
#       https://cf.10xgenomics.com/spatial-gene-expression/datasets/<tissue-name>/<tissue-name>_spatial.tar.gz
#
# You can also browse the webpage of each dataset and download "Feature / barcode matrix (filtered)" and
# "Spatial imaging data" in the file list
# And then unzip the downloaded data and organize folders using the following structure:
#
#       . <data-folder>
#       ├── ...
#       ├── <tissue-folder>
#       │   ├── filtered_feature_bc_matrix
#       │   │   ├── barcodes.tsv.gz
#       │   │   ├── features.tsv.gz
#       │   │   └── matrix.mtx.gz 
#       │   ├── spatial
#       │   │   ├── tissue_positions_list.csv
#       └── ...
#
# To learn more about the filtered feature-barcode matrix data and spatial coordinates, 
# please visit the links below:
#
#       filtered feature-barcode matrix data: 
#       https://support.10xgenomics.com/spatial-gene-expression/software/pipelines/latest/output/matrices
#
#       spatial information:
#       https://support.10xgenomics.com/spatial-gene-expression/software/pipelines/latest/output/images
#

# Package required to run this script
packages <- c("argparser", "Matrix", "R.matlab")

# Install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}

# Load packages
invisible(lapply(packages, library, character.only = TRUE))

# arguments parser
p <- arg_parser("Convert spatial transcriptomics matrix data into tensor format")
p <- add_argument(p, "--input", help="Path to input folder", type="character")
p <- add_argument(p, "--output", help="Path to output folder", type="character")
argv <- parse_args(p)

# List all tissues for convertion
tissue_names <- list.dirs(paste0(argv$input, "/"), full.names = FALSE, recursive = FALSE)

for(tn in tissue_names){

  # Set path to filtered feature-barcode matrix data and spatial coordinates
  matrix_dir <- paste0(argv$input, "/", tn, "/filtered_feature_bc_matrix/")
  barcode.path <- paste0(matrix_dir, "barcodes.tsv.gz")
  features.path <- paste0(matrix_dir, "features.tsv.gz")
  matrix.path <- paste0(matrix_dir, "matrix.mtx.gz")
  spatial_info_dir <- paste0(argv$input, "/", tn, "/spatial/")
  barcode_position.path <- paste0(spatial_info_dir, "tissue_positions_list.csv")

  # Read filtered feature-barcode matrix data
  mat <- readMM(file = matrix.path)
  feature.names <- read.delim(features.path,
                             header = FALSE,
                             stringsAsFactors = FALSE)
  barcode.names <- read.delim(barcode.path,
                             header = FALSE,
                             stringsAsFactors = FALSE)
  colnames(mat) <- barcode.names$V1
  rownames(mat) <- feature.names$V1

  # Write gene names of tensor slice for each tissue to output folder
  fwrite(feature.names, paste0(argv$output, "/", tn, "_gene.csv"))

  # Read spatial coordinates
  barcode_position <- read.delim(barcode_position.path,
                                header = FALSE,
                                sep = ",",
                                stringsAsFactors = FALSE)

  # Align spatial coordinates between rows
  t <- data.frame(x_coords = barcode_position$V3[match(colnames(mat)[mat@j+1], barcode_position$V1)]+1,
                 y_coords = barcode_position$V4[match(colnames(mat)[mat@j+1], barcode_position$V1)]+1,
                 variable = mat@i+1,
                 value = mat@x)

  t$x_aligned_coords <- t$x_coords
  t$y_aligned_coords <- t$y_coords

  t$y_aligned_coords[which(t$x_coords%%2==1)] <- t$y_coords[which(t$x_coords%%2==1)]%/%2+1
  t$y_aligned_coords[which(t$x_coords%%2==0)] <- t$y_coords[which(t$x_coords%%2==0)]%/%2

  t <- t[order(t$x_aligned_coords, t$y_aligned_coords), ]

  # Write tensor data to output folder
  writeMat(paste0(argv$output, "/", tn, ".mat"), V = t, X=78, Y=64, Z=nrow(mat))
}
