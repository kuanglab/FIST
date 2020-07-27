function [maevec,mapevec,r2vec] = evaluate_model(A,V,m,subs_test,uids)
disp('evaluation ...');
Y = tensor(ktensor(A));
Tmat = tenmat(Y,3);
data = Tmat.data;   
data = data.*repmat(m,1,size(data,2));
Y = tensor(tenmat(data,Tmat.rdims,Tmat.cdims,Tmat.tsize));
vals_test_ori = V(subs_test);
pred_test_ori = Y(subs_test);

maevec = zeros(size(uids));
mapevec = zeros(size(uids));
r2vec = zeros(size(uids));
for i =1:length(uids)
    ind = find(subs_test(:,3) == uids(i));
    vals_test = vals_test_ori(ind);
    pred_test = pred_test_ori(ind);

    len_test = length(vals_test);
    se_line = sum((pred_test - vals_test).^2);
    se_y = sum((vals_test - mean(vals_test)).^2);        
    mae_ = sum(abs(pred_test - vals_test))/len_test;
    mape_ = sum(abs(pred_test - vals_test)./abs(vals_test))/len_test;
    r2_ = 1-se_line/se_y;
    maevec(i) = mae_;
    mapevec(i) = mape_;
    r2vec(i) = r2_;
end
end