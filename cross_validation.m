clear all;clc
dataName = 'Mouse_Kidney';
work_path = '/FIST_github';
data_path = [work_path,'/data'];
utils_path =[work_path,'/tensor_toolbox'];
cd(work_path);
[T,W,n] = data_prep(dataName, data_path, utils_path);
%% cross validation
cd(utils_path);
subs = T.subs;
indices = crossvalind('Kfold',subs(:,3),5);% 5-fold cross validation

lambdavec = [0,0.01];
MAE_res = cell(2,5);
MAPE_res = MAE_res;
R2_res = MAE_res;

for test_fold = 1:5
    opts.stopcrit = 10^-4;
    opts.MaxIters = 5;
    opts.dense_mod = 1; % use dense implementation of FIST if the data is NOT sparse
    [A_bag,m,mae_ind,mape_ind,r2_ind] = train_valid_FIST(T,indices,test_fold,n,W,lambdavec,opts);

    % test data
    subs_test = subs(indices == test_fold,:);
    vals_test = T(subs_test); 
    [maevec,mapevec,r2vec] = test_FIST(A_bag,m,mae_ind,...,
    mape_ind,r2_ind,subs_test,vals_test,n,length(lambdavec));
    MAE_res{1,test_fold} = maevec;
    MAPE_res{1,test_fold} = mapevec;
    R2_res{1,test_fold} = r2vec;
    
    % test spatial-NN
    [maevec,mapevec,r2vec] = spatialNN(T,indices,test_fold);
    MAE_res{2,test_fold} = maevec;
    MAPE_res{2,test_fold} = mapevec;
    R2_res{2,test_fold} = r2vec;
end
scatter_plot(MAE_res,'MAE');
scatter_plot(MAPE_res,'MAPE');
scatter_plot(R2_res,'R2');


