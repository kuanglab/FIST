%load the data
% V: input tensor
% W: PPI and spatial graph

work_path = 'yourpath/FIST_data';%replace yourpath with your working path
data_path = 'FIST_Tutorial_Output/';
utils_path = 'FIST_utils';
data_name = 'V1_Human_Heart';
PPI_name = 'HSA_PPI'; %use HSA_PPI.mat for human data and MUS_PPI.mat for mouse data

cd(work_path);
[V,W,rank_k] = data_prep_10x(data_name, PPI_name, data_path, utils_path);

%set parameters
opts.stopcrit = 10^-4;
opts.MaxIters = 5;
opts.dense_mod = 0; % use dense implementation of FIST if the data is NOT sparse
opts.rank = rank_k;
opts.lambda = 0.01; %parameter for visium data
   
% prepare the mask
M = sptensor(V.subs,ones(size(V.vals)),size(V)); % mask tensor

% run FIST
A = FIST(V,M,W,opts); 

% get the output tensor
Y = tensor(ktensor(A)); % output tensor in cpd-form


% save both the factor matrices and the tensor
cd(work_path);
save([data_path,data_name,'_output.mat'],'A','Y');
