clear all;clc

data_bag = {'HBA1','HBA2','HH','HLN','MKC','MBC','MB1P','MB2P','MB1A','MB2A'};
work_path = 'yourpath/FIST_data';
data_path = '10x_data/';
utils_path = 'FIST_utils/';
res_path = '../SpatialNN_res/slice_wise_10x/';
for nameid = 1:10
    cd(work_path); 
    data_name = data_bag{nameid};
    % prepare data tensor and graphs    
    [V,W,n] = data_prep_10x_slice(data_name, data_path, utils_path); 
    %% 5-fold cross-validation on each gene slice
    subs = V.subs;
    rng(0);
    indices = crossvalind('Kfold',subs(:,3),5);% 5-fold cross validation

    for test_fold = 1:5
        subs_train_ori = subs(indices ~= test_fold,:);
        vals_train_ori = V(subs_train_ori);
        subs_test_ori = subs(indices == test_fold,:);
        vals_test_ori = V(subs_test_ori);
        uids = unique(subs_test_ori(:,3));
        maevec = zeros(size(uids));
        mapevec = zeros(size(uids));
        r2vec = zeros(size(uids));
        for i =1:length(uids)
            if mod(i,10)==0
                disp(['running spatial-NN ... gene: ',num2str(i)]);
            end
            ind = subs_test_ori(:,3) == uids(i);
            subs_test = subs_test_ori(ind,1:2);
            vals_test = vals_test_ori(ind);

            ind = subs_train_ori(:,3) == uids(i);
            subs_train = subs_train_ori(ind,1:2); 
            vals_train = vals_train_ori(ind);

            pred_test = vals_test - vals_test;
            for row = 1:length(vals_test)
                dis  = sum((subs_train - subs_test(row,:)).^2,2);
                pred_test(row) = mean(vals_train(dis == min(dis)));
            end

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
        maeres{1} = maevec;
        maperes{1} = mapevec;
        r2res{1} = r2vec;
        
        name=[res_path,'Spatial1NN_10xslice_',data_bag{nameid},'_fold',num2str(test_fold),'.mat'];
        save(name, 'maeres','maperes','r2res','-v7.3'); 
    end
   
end


