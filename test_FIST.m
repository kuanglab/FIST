function [maevec,mapevec,r2vec] = test_FIST(A_bag,m,mae_ind,...,
    mape_ind,r2_ind,subs_test,vals_test,n,nparas)
T_ori = sptensor(subs_test,vals_test,n);
uids = unique(subs_test(:,3));
mae_mat = zeros(length(uids), nparas);
r2_mat  = mae_mat;
mape_mat =  mae_mat;

for i = 1:length(nparas)
    [maevec,mapevec,r2vec] = evaluate_model(A_bag{i},T_ori,m,subs_test,uids);
    mae_mat(:,i) = maevec;
    r2_mat(:,i) = r2vec;
    mape_mat(:,i) = mapevec;
end
maevec = zeros(length(uids),1);
mapevec = maevec;
r2vec = maevec;
for i=1:length(uids)
    maevec(i) = mae_mat(i,mae_ind(i));
    mapevec(i) = mape_mat(i,mape_ind(i));
    r2vec(i) = r2_mat(i,r2_ind(i));
end
end

