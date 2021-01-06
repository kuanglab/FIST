# FIST: Fast Imputation of Spatially-resolved transcriptomes by graph-regularized Tensor completion

## Preparation for the experiments
To prepare for the experiments, 1) download the directory `FIST_data` from this [link](http://compbio.cs.umn.edu/FIST_data.tgz); and 2) download all the script files in this GitHub repo to the `FIST_data` directory.
The folders (10x_data, Replicates_data, FIST_utils, FIST_res, SpatialNN_res, REMAP_res, GWNMF_res, ZIFA_res) in `FIST_data` are described below:
#### Dataset folder
- **`10x_data`:** 1) The spatial gene expression tensors from 10 tissue sections (HBA1, HBA2, HH, HLN, MKC, MBC, MB1P, MB2P, MB1A, MB2A); 2) The Homo sapiens and Mus musculus protein-protein interactions (PPI) networks obtained from [BioGRID](https://thebiogrid.org/);  3) The gene ids for each of the 10 tissue sections. 

(Note: We also provide the R script `Convert2Tensor_Visium.R` with step-by-step instructions on how to convert the raw spatial transcriptomic datasets from [10x Genomics](https://support.10xgenomics.com/spatial-gene-expression/datasets/) to tensors.)
- **`Replicates_data`**: 1) The spatial gene expression tensors from 3 replicates of mouse tissue (olfactory bulb);  2) The Mus musculus protein-protein interactions (PPI) networks obtained from [BioGRID](https://thebiogrid.org/); 3) The gene ids for each of the 3 replicates.

(Note: We also provide the R script `Convert2Tensor_ST.R` with step-by-step instructions on how to convert the raw spatial transcriptomic datasets from [Ståhl et al. (2016)](https://www.spatialresearch.org/resources-published-datasets/doi-10-1126science-aaf2403/) to tensors.)
#### Utility folder
- **`FIST_utils`:** The utility files required for running FIST, which includes 1) the main function `FIST.m`; 2) the supporting functions `train_valid_FIST.m` and `test_FIST.m` for the gene-wise cross-validation on the 10x Genomics data; 3) all the files in the [MATLAB Tensor Toolbox](https://gitlab.com/tensors/tensor_toolbox) package.
#### Result folder
The cross-validation results for FIST are stored in `FIST_res`. The cross-validation results for the baseline methods [REMAP](https://github.com/hansaimlim/REMAP), [GWNMF](https://locus.siam.org/doi/pdf/10.1137/1.9781611972801.18), [ZIFA](https://github.com/epierson9/ZIFA) and Sptial-NN are stored in `REMAP_res`, `GWNMF_res`, `ZIFA_res` and `SpatialNN_res`. (Note: Spatial-NN is a baseline method created by ourselves, the implementation is provided in this GitHub repo.)

## Instructions to run cross-validation experiments
#### Step 1: generate the tensor data from the raw data (skip this step if directly work on the processed tensor data)
Step-by-step instructions on how to convert the raw spatial transcriptomic datasets from [10x Genomics](https://support.10xgenomics.com/spatial-gene-expression/datasets/) and [Ståhl et al. (2016)](https://www.spatialresearch.org/resources-published-datasets/doi-10-1126science-aaf2403/) to tensors are provided in `Convert2Tensor_Visium.R` and `Convert2Tensor_ST.R` respectively.  To run these R scripts, you need to specify the paths to input and output folders by using "--input" and "--output" in the command line on Linux as follows:
```
Rscript Convert2Tensor_Visium.R --input <input_folder> --output <output_folder>
Rscript Convert2Tensor_ST.R --input <input_folder> --output <output_folder>  
```
Next, open MATLAB and load the `.mat` file output by the `Rscript` command in the previous step, `cd` to the `FIST_utils` folder, and run `V = sptensor([V.x_aligned_coords V.y_aligned_coords V.variable], V.value, [double(X) double(Y) double(Z)]);` to generate the data tensor.
#### Step 2: Run cross-validations on the spot fibers or gene slices of the processed tensors
- **Spot-wise cross-validation on the 10x Genomics data:**  Run `FIST_crossvalidation_10xfiber.m` and `SpatialNN_crossvalidation_10xfiber.m` to test FIST and the baseline Spatial-NN respectively.
- **Gene-wise cross-validation on the 10x Genomics data:**  Run `FIST_crossvalidation_10xslice.m` and `SpatialNN_crossvalidation_10xslice.m` to test FIST and the baseline Spatial-NN respectively. 
- **Spot-wise cross-validation on the mouse tissue replicates data:**  Run `FIST_crossvalidation_replicates_fiber.m` and `SpatialNN_crossvalidation_replicates_fiber.m` to test FIST and the baseline Spatial-NN respectively.
#### Step 3: Display the results
Run `plot_Figure2.m`, `plot_Figure3.m`, `plot_Figure4.m`, `plot_Figure8.m`, `plot_Figure9.m`, `plot_FigureS123.m` and `generate_S2_Table.m` to display the key results in the paper.



