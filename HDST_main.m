clear all;clc
dataName = 'CN24_E1';
work_path = '/FIST_github';
data_path = [work_path,'/data'];
utils_path =[work_path,'/tensor_toolbox'];
cd(work_path);
[T,W,n] = data_prep_HDST(dataName, data_path, utils_path);

%% data normalization
cd(utils_path);
% disp('data normalization ...');
% Tmat = tenmat(T,3);
% data = Tmat.data;
% m = max(data,[],2); % normalize each gene by its larget value
% data = data./repmat(m,1,size(data,2));
% T = sptensor(tensor(tenmat(data,Tmat.rdims,Tmat.cdims,Tmat.tsize)));
% disp('data normalization done!');
%% determine the tensor CPD rank
disp('determine CPD rank ...');
opts.rank = 300;
% to determine the CPD rank by PCA
% uncomment the following code
% rank_k = get_rank(data); 
% opts.rank
disp(['CPD rank is: ',num2str(opts.rank)]);
%%
opts.stopcrit = 10^-4;
opts.MaxIters = 10;
opts.dense_mod = 0; % use sparse implementation of FIST 
opts.lambda = 0;
t_start = tic;
A = FIST(T,W,opts);
t_end = toc(t_start);
disp(['running time(s): ',num2str(t_end)]);
%% construct the imputed tensor Y
% Y = tensor(ktensor(A));
% Tmat = tenmat(Y,3);
% data = Tmat.data;   
% data = data.*repmat(m,1,size(data,2));
% Y = tensor(tenmat(data,Tmat.rdims,Tmat.cdims,Tmat.tsize));
