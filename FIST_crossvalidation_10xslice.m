clear all;clc

opts.stopcrit = 10^-4;
opts.MaxIters = 500;
opts.dense_mod = 1; % use dense implementation of FIST if the data is NOT sparse

data_bag = {'HBA1','HBA2','HH','HLN','MKC','MBC','MB1P','MB2P','MB1A','MB2A'};
work_path = 'yourpath/FIST_data';
data_path = '10x_data/';
utils_path = 'FIST_utils/';
res_path = '../FIST_res/slice_wise_10x/';
lambdavec = [0, 0.01];
for nameid = 1:10
    cd(work_path); 
    data_name = data_bag{nameid};
    % prepare data tensor and graphs    
    [T_ori,W,n] = data_prep_10x_slice(data_name, data_path, utils_path); 
    %% 5-fold cross-validation on each gene slice
    subs = T_ori.subs;
    indices = crossvalind('Kfold',subs(:,3),5);% 5-fold cross validation

    for test_fold = 1:5

        train_val_fold = setdiff([1:5],test_fold);
        train_fold = train_val_fold(1:3);
        val_fold = train_val_fold(end);
        train_indices = indices(ismember(indices,train_fold));
        valid_indices = indices(indices == val_fold);
        test_indices = indices(indices == test_fold);

        [A_bag,m,ind_bag] = train_valid_FIST(lambdavec,T_ori,train_indices,valid_indices,n,W,opts);   

        % test data
        [maevec,mapevec,r2vec] = test_FIST(T_ori,test_indices,A_bag,m,ind_bag,length(lambdavec));
        maeres{1} = maevec;
        maperes{1} = mapevec;
        r2res{1} = r2vec;
        name=[res_path,'FIST_10xslice_',data_bag{nameid},'_fold',num2str(test_fold),'.mat'];
        save(name,'maeres','maperes','r2res','-v7.3'); 
    end
   
end


