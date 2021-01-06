clear all;clc
data_bag = {'Replicate 1','Replicate 2','Replicate 3'};
work_path = 'yourpath/FIST_data';
data_path = 'Replicates_data/';
utils_path = 'FIST_utils/';
res_path = '../SpatialNN_res/fiber_wise_replicates/';

for nameid = 1:3
    cd(work_path); 
    % prepare data tensor and graphs    
    [V,W,~] = data_prep_Rep(nameid, data_path, utils_path);
    %% 5-fold cross-validation on spot fibers
    Z = collapse(V,3);
    for fold = 1:5
        rng('default');
        indices = crossvalind('Kfold',ones(size(Z.subs,1),1),5); 
        test_idx = find(indices==fold);
        test_subs = Z.subs(test_idx,:);
        V_subs = V.subs;
        V_vals = V.vals; 
        Lia = ismember(V_subs(:,1:2),test_subs,'rows');
        V_subs(Lia,:) = [];
        V_vals(Lia) = [];
        Y0 = sptensor(V_subs,V_vals,size(V)); % training tensor
        subs_train = Y0.subs;
        vals_train = Y0.vals;
        
        maevec = zeros(size(test_subs,1),1);
        mapevec = maevec;
        r2vec = maevec;
        for i =1:size(test_subs,1)
            i
            test_row = test_subs(i,:);
            vals_test = double(V(test_subs(i,1),test_subs(i,2),:));
            pred_test = zeros(size(vals_test));
            nnz_id = find(vals_test>0);
            for idx = 1:length(nnz_id)
                gid = nnz_id(idx);
                ind = find(subs_train(:,3) == gid);
                if ~isempty(ind)
                    train_subs_select = subs_train(ind,1:2);
                    train_vals_select = vals_train(ind);
                    % search the non-zero neighbor sopts
                    dis = sum((train_subs_select - test_row).^2,2);
                    train_vals_select = train_vals_select(dis == min(dis));
                    pred_test(gid) = mean(train_vals_select);
                else
                    pred_test(gid) = 0;
                end
                    
            end
            
            pred_test = pred_test(vals_test>0);
            vals_test = vals_test(vals_test>0);

            len_test = length(vals_test);
            se_line = sum((pred_test - vals_test).^2);
            se_y = sum((vals_test - mean(vals_test)).^2);        
            mae_ = sum(abs(pred_test - vals_test))/len_test;
            mape_ = sum(abs(pred_test - vals_test)./abs(vals_test))/len_test;
            r_ = 1-se_line/se_y;
            maevec(i) = mae_;
            mapevec(i) = mape_;
            r2vec(i) = r_;
        end 
 
        name=[res_path,'Spatial1NN_replicates_fiber_',data_bag{nameid},'_fold',num2str(fold),'.mat'];
        save(name,'maevec','mapevec','r2vec','-v7.3'); 
    end
end

