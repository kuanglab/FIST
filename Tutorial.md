# FIST: Fast Imputation of Spatially-resolved transcriptomes by graph-regularized Tensor completion

This tutorial shows how to download a visium dataset and run FIST for the imputation.

#Step 1: download Visium dataset.
You can downloaded any Visium data (Space Ranger v1.0.0) to from [10x genomics website](https://support.10xgenomics.com/spatial-gene-expression/datasets/).
In this tutorial, we will use a human heart dataset as an example. We only use filtered feature-barcode matrix data and spatial coordindates. they can be downloaded with following links [filtered feature-barcode matrix data] (https://cf.10xgenomics.com/samples/spatial-exp/1.0.0/V1_Human_Heart/V1_Human_Heart_filtered_feature_bc_matrix.tar.gz) and [spatial coordinates](https://cf.10xgenomics.com/spatial-gene-expression/datasets/V1_Human_Heart/V1_Human_Heart_spatial.tar.gz). Then unzip the downloaded data and organize folders using the following structure under a home-folder for your experiment:

       . <home-folder>
       ├── V1_Human_Heart
       │   ├── filtered_feature_bc_matrix
       │   │   ├── barcodes.tsv.gz
       │   │   ├── features.tsv.gz
       │   │   └── matrix.mtx.gz 
       │   ├── spatial
       │   │   ├── tissue_positions_list.csv

(more about [filtered feature-barcode matrix data](https://support.10xgenomics.com/spatial-gene-expression/software/pipelines/latest/output/matrices) and [spatial coordinates](https://support.10xgenomics.com/spatial-gene-expression/software/pipelines/latest/output/images)

#Step 2: convert a single visium dataset into tensor data for running fist.
