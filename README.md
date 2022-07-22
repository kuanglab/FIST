# FIST: Fast Imputation of Spatially-resolved transcriptomes by graph-regularized Tensor completion

## Preparation for the experiments
To prepare for the experiments, 1) download the directory `FIST_data` from this [link](http://compbio.cs.umn.edu/FIST_package.tgz); and 2) download all the script files in this GitHub repo to the `FIST_data` directory.
The folders (10x_data, Replicates_data, FIST_utils, FIST_res, SpatialNN_res, REMAP_res, GWNMF_res, ZIFA_res) in `FIST_data` are described below:
#### Dataset folder
- **`10x_data`:** 1) The spatial gene expression tensors from 10 tissue sections (HBA1, HBA2, HH, HLN, MKC, MBC, MB1P, MB2P, MB1A, MB2A); 2) The Homo sapiens and Mus musculus protein-protein interactions (PPI) networks obtained from [BioGRID](https://thebiogrid.org/);  3) The gene ids for each of the 10 tissue sections. 
- **`Replicates_data`**: 1) The spatial gene expression tensors from 3 replicates of mouse tissue (olfactory bulb);  2) The Mus musculus protein-protein interactions (PPI) networks obtained from [BioGRID](https://thebiogrid.org/); 3) The gene ids for each of the 3 replicates.

(Note: We also provide the R script `Convert2Tensor_Visium.R` and `Convert2Tensor_ST.R` with step-by-step instructions on how to convert the raw spatial transcriptomic datasets from [10x Genomics](https://support.10xgenomics.com/spatial-gene-expression/datasets/) and [Ståhl et al. (2016)](https://www.spatialresearch.org/resources-published-datasets/doi-10-1126science-aaf2403/) to tensors.)
#### Utility folder
- **`FIST_utils`:** The utility files required for running FIST, which includes 1) the main function `FIST.m`; 2) the supporting functions `train_valid_FIST.m` and `test_FIST.m` for the gene-wise cross-validation on the 10x Genomics data; 3) all the files in the [MATLAB Tensor Toolbox](https://gitlab.com/tensors/tensor_toolbox) package.
#### Result folder
The cross-validation results for FIST are stored in `FIST_res`. The cross-validation results for the baseline methods [REMAP](https://github.com/hansaimlim/REMAP), [GWNMF](https://locus.siam.org/doi/pdf/10.1137/1.9781611972801.18), [ZIFA](https://github.com/epierson9/ZIFA) and Sptial-NN are stored in `REMAP_res`, `GWNMF_res`, `ZIFA_res` and `SpatialNN_res`. (Note: Spatial-NN is a baseline method created by ourselves, the implementation is provided in this GitHub repo.)

## Tutorial to run FIST on a Visium dataset
#### Step 1: download a Visium dataset.
You can downloaded any Visium data (Space Ranger v1.0.0) to from [10x genomics website](https://support.10xgenomics.com/spatial-gene-expression/datasets/).
In this tutorial, we will use a human heart dataset as an example. 

Under Visium Spatial for FFPE Demonstration (v1 Chemistry)/Visium Demonstration (v1 Chemistray) choose tab "Space Ranger v1.0.0". Click the "Human Heart" link, fill in the form and check the concensus to access the data. 

We only use filtered feature-barcode matrix data and spatial coordindates provided in the download file list. They can also be downloaded with following links [filtered feature-barcode matrix data](https://cf.10xgenomics.com/samples/spatial-exp/1.0.0/V1_Human_Heart/V1_Human_Heart_filtered_feature_bc_matrix.tar.gz) and [spatial coordinates](https://cf.10xgenomics.com/spatial-gene-expression/datasets/V1_Human_Heart/V1_Human_Heart_spatial.tar.gz). 

Then unzip the downloaded data and organize folders using the following structure under a home-folder for your experiment:

       . FIST_Tutorial
       ├── V1_Human_Heart
       │   ├── filtered_feature_bc_matrix
       │   │   ├── barcodes.tsv.gz
       │   │   ├── features.tsv.gz
       │   │   └── matrix.mtx.gz 
       │   ├── spatial
       │   │   ├── tissue_positions_list.csv

(more about [filtered feature-barcode matrix data](https://support.10xgenomics.com/spatial-gene-expression/software/pipelines/latest/output/matrices) and [spatial coordinates](https://support.10xgenomics.com/spatial-gene-expression/software/pipelines/latest/output/images))

#### Step 2: convert the visium data file into tensor data for running FIST.
Create a folder **`FIST_Tutorial_Ouput`** under **`FIST_data`**. Use the following command line to run the R script for converting the data

Rscript Convert2Tensor_Visium.R --input FIST_Tutorial --output FIST_Tutorial_Output

After running the script, a matlab file V1_Human_Heart.mat and a gene list file V1_Human_Heart.csv will be generated in the folder **`FIST_Tutorial_Output`**.

#### Step 3: run FIST program
Open the script run_FIST_Tutorial.m in matlab. Replace yourpath in the line "work_path = 'yourpath/FIST_data';" with the FIST installation directory. Then run the script. The imputed tensor will be saved in V1_Human_Heart_output.mat in the folder **`FIST_Tutorial_Output`**

### Note: 
This tutorial only works for human and mouse visium data. To work with other species, you need to dowload PPI networks and prepare them in .mat format under the folder **`FIST_Tutorial_Output`** and change the code in data_prep_10x.m to read in the PPI.

## Instructions to run cross-validation experiments
#### Step 1: generate the tensor data from the raw data (skip this step if directly work on the processed tensor data in the preparation step)
The tensor data are already prepared by `Convert2Tensor_Visium.R` and `Convert2Tensor_ST.R` in the folder **`10x_data`**. 

#### Step 2: Run cross-validations on the spot fibers or gene slices of the processed tensors
Next, open MATLAB and load the `.mat` file provided in the preparation under **`10x_data`** folder or outputted by the `Rscript` command in the previous step, `cd` to the `FIST_utils` folder, and run `V = sptensor([V.x_aligned_coords V.y_aligned_coords V.variable], V.value, [double(X) double(Y) double(Z)]);` to generate the data tensor.

- **Spot-wise cross-validation on the 10x Genomics data:**  Run `FIST_crossvalidation_10xfiber.m` and `SpatialNN_crossvalidation_10xfiber.m` to test FIST and the baseline Spatial-NN respectively.
- **Gene-wise cross-validation on the 10x Genomics data:**  Run `FIST_crossvalidation_10xslice.m` and `SpatialNN_crossvalidation_10xslice.m` to test FIST and the baseline Spatial-NN respectively. 
- **Spot-wise cross-validation on the mouse tissue replicates data:**  Run `FIST_crossvalidation_replicates_fiber.m` and `SpatialNN_crossvalidation_replicates_fiber.m` to test FIST and the baseline Spatial-NN respectively.

#### Step 3: Display the results
Run `plot_Figure2.m`, `plot_Figure3.m`, `plot_Figure4.m`, `plot_Figure8.m`, `plot_Figure9.m`, `plot_FigureS345.m` and `generate_S1_Table.m` to display the key results in the paper.


## Reference
[Li, Zhuliu, Tianci Song, Jeongsik Yong, and Rui Kuang. "Imputation of spatially-resolved transcriptomes by graph-regularized tensor completion." PLoS computational biology 17, no. 4 (2021): e1008218.](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1008218)


