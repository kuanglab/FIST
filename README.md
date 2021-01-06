# FIST: Fast Imputation of Spatially-resolved transcriptomes by graph-regularized Tensor completion
## Preparation for the experiments
To prepare for the experiments, 1) download the directory `FIST_data` from this [link](http://compbio.cs.umn.edu/FIST_data.tgz); and 2) download all the script files in this GitHub repo to the `FIST_data` direcotry.
The folders (10x_data, Replicates_data, FIST_utils, FIST_res, SpatialNN_res, REMAP_res, GWNMF_res, ZIFA_res) in `FIST_data` are described below:
#### Dataset
- **`10x_data`:** 1) The spatial gene expression tensors from 10 tissue sections (HBA1, HBA2, HH, HLN, MKC, MBC, MB1P, MB2P, MB1A, MB2A); 2) The Homo sapiens and Mus musculus protein-protein interactions (PPI) networks obtained from [BioGRID](https://thebiogrid.org/);  3) The gene ids for each of the 10 tissue sections.
(Note: We also provide the R script `Convert2Tensor_Visium.R` with step-by-step instructions on how to convert the raw spatial transcriptomic datasets from [10x Genomics](https://support.10xgenomics.com/spatial-gene-expression/datasets/) to tensors.)
- **`Replicates_data`**: 1) The spatial gene expression tensors from 3 replicates of mouse tissue (olfactory bulb);  2) The Mus musculus protein-protein interactions (PPI) networks obtained from [BioGRID](https://thebiogrid.org/); 3) The gene ids for each of the 3 replicates.
(Note: We also provide the R script `Convert2Tensor_ST.R` with step-by-step instructions on how to convert the raw spatial transcriptomic datasets from [Ståhl et al. (2016)](https://www.spatialresearch.org/resources-published-datasets/doi-10-1126science-aaf2403/) to tensors.)

#### Utility files
- **`FIST_utils`:** The utility files required for running FIST, which includes 1) the main function `FIST.m`; 2) the supporting functions `train_valid_FIST.m` and `test_FIST.m` for the gene-wise cross-validation on 10x Genomics datasets; 3) all the files in the [MATLAB Tensor Toolbox](https://gitlab.com/tensors/tensor_toolbox) package.
#### Results
The cross-validation results for FIST are stored in `FIST_res`. The cross-validation results for the baseline methods [REMAP](https://github.com/hansaimlim/REMAP), [GWNMF](https://locus.siam.org/doi/pdf/10.1137/1.9781611972801.18), [ZIFA](https://github.com/epierson9/ZIFA) and Sptial-NN are stored in `REMAP_res`, `GWNMF_res`, `ZIFA_res` and `SpatialNN_res`. (Note: Spatial-NN is a baseline method created by ourserlves whose implementation is provided in this GitHub repo as described in the "Script files" section.)

## Script files in this GitHub repo


