clear all;clc

opts.stopcrit = 10^-4;
opts.MaxIters = 500;
opts.dense_mod = 1; % use dense implementation of FIST if the data is NOT sparse

data_bag = {'HBA1','HBA2','HH','HLN','MKC','MBC','MB1P','MB2P','MB1A','MB2A'};
work_path = 'yourpath/FIST_data';
data_path = '10x_data/';
utils_path = 'FIST_utils/';
res_path = '../FIST_res/fiber_wise_10x/';

lambdavec = [0, 0.01, 0.1, 1];
for nameid = 1:10
    cd(work_path); 
    data_name = data_bag{nameid};
    % prepare data tensor and graphs
    [V,W,rank_k] = data_prep_10x_fiber(data_name, data_path, utils_path); 
    opts.rank = rank_k;
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

        maeres = cell(length(lambdavec),1);
        maperes = maeres;
        r2res = maeres;
        for lambdai = 1:length(lambdavec)
            opts.lambda = lambdavec(lambdai);
            M = sptensor(Y0.subs,ones(size(Y0.vals)),size(Y0)); % mask tensor
            A = FIST(Y0,M,W,opts); 
            Y = tensor(ktensor(A)); % output tensor in cpd-form
            maevec = zeros(size(test_subs,1),1);
            mapevec = maevec;
            r2vec = maevec;
            for i =1:length(maevec)
                i
                vals_test = double(V(test_subs(i,1),test_subs(i,2),:));
                pred_test = double(Y(test_subs(i,1),test_subs(i,2),:));
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
            maeres{lambdai} = maevec;
            maperes{lambdai} = mapevec;
            r2res{lambdai} = r2vec;
        end
        name=[res_path,'FIST_10xfiber_',data_bag{nameid},'_fold',num2str(fold),'.mat'];
        save(name,'maeres','maperes','r2res','-v7.3'); 
    end
end

