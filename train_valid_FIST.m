function [A_bag,m,mae_ind,mape_ind,r2_ind] = train_valid_FIST(T_ori,indices,test_fold,n,W,lambdavec,opts)
%% data normalization
disp('data normalization ...');
Tmat = tenmat(T_ori,3);
data = Tmat.data;
m = max(data,[],2);
data = data./repmat(m,1,size(data,2));
T = sptensor(tensor(tenmat(data,Tmat.rdims,Tmat.cdims,Tmat.tsize)));
disp('data normalization done!');
subs = T.subs;
subs_train_vali = subs(indices ~= test_fold,:); % training + validation data
vals_train_vali = T(subs_train_vali);
indices_train_vali = indices(indices ~= test_fold);
T = sptensor(subs_train_vali,vals_train_vali,n);

%% determine the tensor CPD rank
disp('determine CPD rank ...');
Tmat = tenmat(T,3);
data = Tmat.data;
rank_k = get_rank(data);
opts.rank = rank_k;
disp(['CPD rank is: ',num2str(rank_k)]);
%%

% training data
subs_train = subs_train_vali(indices_train_vali ~= indices_train_vali(1),:);
vals_train = T(subs_train);
T_train = sptensor(subs_train,vals_train,n);

% validation data
subs_val = subs_train_vali(indices_train_vali == indices_train_vali(1),:);
uids = unique(subs_val(:,3));

% evaluate by mae r2 and mape
mae_mat = zeros(length(uids), length(lambdavec));
r2_mat  = mae_mat;
mape_mat =  mae_mat;

% use 3-fold training and 1-fold validation
for lambda_i = 1:length(lambdavec)
    opts.lambda = lambdavec(lambda_i);
    A = FIST(T_train,W,opts);
    [maevec,mapevec,r2vec] = evaluate_model(A,T_ori,m,subs_val,uids);
    mae_mat(:,lambda_i) = maevec;
    r2_mat(:,lambda_i) = r2vec;
    mape_mat(:,lambda_i) = mapevec;
end
[~,mae_ind] = min(mae_mat,[],2);
[~,r2_ind] = max(r2_mat,[],2);
[~,mape_ind] = min(mape_mat,[],2);


% combine the 4 folds together to train again
A_bag = cell(length(lambdavec),1);
for lambda_i = 1:length(lambdavec) 
    opts.lambda = lambdavec(lambda_i);
    A = FIST(T,W,opts);
    A_bag{lambda_i} = A;
end


end


