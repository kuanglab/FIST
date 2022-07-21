# FIST: Fast Imputation of Spatially-resolved transcriptomes by graph-regularized Tensor completion

This tutorial shows how to download a visium dataset and run FIST for the imputation.

# Step 1: download FIST package
Follow the step in [Preparation of the experiments](https://github.com/kuanglab/FIST/blob/master/README.md#preparation-for-the-experiments) to prepare all the data and the folders. Under the **`FIST_data`:** directory create a directory **`FIST_tutorial`**.

# Step 2: download a Visium dataset.
You can downloaded any Visium data (Space Ranger v1.0.0) to from [10x genomics website](https://support.10xgenomics.com/spatial-gene-expression/datasets/).
In this tutorial, we will use a human heart dataset as an example. 

Under Visium Spatial for FFPE Demonstration (v1 Chemistry)/Visium Demonstration (v1 Chemistray) choose tab "Space Ranger v1.0.0". Click the "Human Heart" link, fill in the form and check the concensus to access the data. 

We only use filtered feature-barcode matrix data and spatial coordindates provided in the download file list. They can also be downloaded with following links [filtered feature-barcode matrix data](https://cf.10xgenomics.com/samples/spatial-exp/1.0.0/V1_Human_Heart/V1_Human_Heart_filtered_feature_bc_matrix.tar.gz) and [spatial coordinates](https://cf.10xgenomics.com/spatial-gene-expression/datasets/V1_Human_Heart/V1_Human_Heart_spatial.tar.gz). 

Then unzip the downloaded data and organize folders using the following structure under a home-folder for your experiment:

       . FIST_tutorial
       ├── V1_Human_Heart
       │   ├── filtered_feature_bc_matrix
       │   │   ├── barcodes.tsv.gz
       │   │   ├── features.tsv.gz
       │   │   └── matrix.mtx.gz 
       │   ├── spatial
       │   │   ├── tissue_positions_list.csv

(more about [filtered feature-barcode matrix data](https://support.10xgenomics.com/spatial-gene-expression/software/pipelines/latest/output/matrices) and [spatial coordinates](https://support.10xgenomics.com/spatial-gene-expression/software/pipelines/latest/output/images))

# Step 3: convert the visium data file into tensor data for running FIST.
Use the following command line to run the R script for converting the data

Rscript Convert2Tensor_Visium.R --input FIST_Tutorial --output FIST_Tutorial_output

After running the script, a matlab file V1_Human_Heart.mat and a gene list file V1_Human_Heart.csv will be generated.

# Step 4: run FIST program
open MATLAB and load V1_Human_Heart.mat file outputted by the Rscript command in the previous step, cd to the FIST_utils folder, run run_FIST.m. After the program completes, run V = sptensor([V.x_aligned_coords V.y_aligned_coords V.variable], V.value, [double(X) double(Y) double(Z)]); to generate the data tensor.
