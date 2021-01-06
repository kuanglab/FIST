# FIST: Fast Imputation of Spatially-resolved transcriptomes by graph-regularized Tensor completion
## Preparation for the experiments
To prepare for the experiments, 1) download the directory `FIST_data` from this [link](http://compbio.cs.umn.edu/FIST_data.tgz); and 2) download all the script files in this repo to the `FIST_data` direcotry.
The folders in `FIST_data` are listed below
### Dataset
- **10x_data:** 1) The spatial gene expression tensors from 10 tissue sections (HBA1, HBA2, HH, HLN, MKC, MBC, MB1P, MB2P, MB1A, MB2A); 2) The Homo sapiens and Mus musculus protein-protein interactions (PPI) networks obtained from [BioGRID](https://thebiogrid.org/) 
from BioGRID  3) The gene ids for each of the 10 tissue sections.
(Note: We also provide the R script `Convert2Tensor_Visium.R` with step-by-step instructions on how to convert the raw spatial transcriptomic datasets from [10x Genomics](https://support.10xgenomics.com/spatial-gene-expression/datasets/) to tensors.)
- **Replicates_data**: 1) The spatial gene expression tensors from 3 replicates of mouse tissue (olfactory bulb);  2) The Mus musculus protein-protein interactions (PPI) networks obtained from [BioGRID](https://thebiogrid.org/) 
from BioGRID  3) The gene ids for each of the 3 replicates.
(Note: We also provide the R script `Convert2Tensor_ST.R` with step-by-step instructions on how to convert the raw spatial transcriptomic datasets from [Ståhl et al. (2016)](https://www.spatialresearch.org/resources-published-datasets/doi-10-1126science-aaf2403/) to tensors.)

### Utility files
- **FIST_utils:** 
### Results
- **FIST_res**: 
- **SpatialNN_res**: 
- **REMAP_res**: 
- **GWNMF_res**:
- **ZIFA_res**: 

## Script files 

