clear all;clc;close all;
data_bag = {'HBA1','HBA2','HH','HLN','MKC','MBC','MB1P','MB2P','MB1A','MB2A'};
pval_table = zeros(10,3,3);
measures = {'MAE','MAPE','R2'};
for plot_idx = 1:3
    for nameid=1:10
        %% FIST
        vec_mae = [];
        vec_mape = [];
        vec_r2 = [];

        for fold=1:5
            fname=['FIST_10xfiber_',data_bag{nameid},'_fold',num2str(fold),'.mat'];
            load(['FIST_res/fiber_wise_10x/',fname]);    
            x = r2res{3};
            vec_mae = [vec_mae;maeres{3}(~isinf(x))];
            vec_mape = [vec_mape;maperes{3}(~isinf(x))];
            vec_r2 = [vec_r2;r2res{3}(~isinf(x))];
        end
        Data_mae{1} = vec_mae;
        Data_mape{1} = vec_mape;
        Data_r2{1} = vec_r2;


        %% GWNMF
        vec_mae = [];
        vec_mape = [];
        vec_r2 = [];

        for fold=1:5
            fname=['GWNMF_10xfiber_',data_bag{nameid},'_fold',num2str(fold),'.mat'];
            load(['GWNMF_res/fiber_wise_10x/',fname]);    
            x = r2res{1};
            vec_mae = [vec_mae;maeres{1}(~isinf(x))];
            vec_mape = [vec_mape;maperes{1}(~isinf(x))];
            vec_r2 = [vec_r2;r2res{1}(~isinf(x))];
        end
        Data_mae{2} = vec_mae;
        Data_mape{2} = vec_mape;
        Data_r2{2} = vec_r2;

        %% SpatialNN
        vec_mae = [];
        vec_mape = [];
        vec_r2 = [];

        for fold=1:5
            fname = ['Spatial1NN_10xfiber_',data_bag{nameid},'_fold',num2str(fold),'.mat'];
            load(['SpatialNN_res/fiber_wise_10x/',fname]);    
            x = r2vec;
            vec_mae = [vec_mae;maevec(~isinf(x))];
            vec_mape = [vec_mape;mapevec(~isinf(x))];
            vec_r2 = [vec_r2;r2vec(~isinf(x))];
        end
        Data_mae{3} = vec_mae;
        Data_mape{3} = vec_mape;
        Data_r2{3} = vec_r2;

        %% REMAP
        vec_mae = [];
        vec_mape = [];
        vec_r2 = [];

        for fold=1:5
            fname=['REMAP_10xfiber_',data_bag{nameid},'_fold',num2str(fold),'.mat'];
            load(['REMAP_res/fiber_wise_10x/',fname]);    
            x = r2res{1};
            vec_mae = [vec_mae;maeres{1}(~isinf(x))];
            vec_mape = [vec_mape;maperes{1}(~isinf(x))];
            vec_r2 = [vec_r2;r2res{1}(~isinf(x))];
        end
        Data_mae{4} = vec_mae;
        Data_mape{4} = vec_mape;
        Data_r2{4} = vec_r2;


        Data_box = {Data_mae,Data_mape,Data_r2};
        Data = Data_box{plot_idx};
        
        x = Data{1};
        for method_i=2:4
            y = Data{method_i};
            if plot_idx == 3
                % test if the mean of R2 is higher than baselines
                [~,pval_table(nameid,plot_idx,method_i-1)] = ttest(x,y,'Tail','right');
            else
                % test if the mean of MAE or MAPE is lower than baselines
                [~,pval_table(nameid,plot_idx,method_i-1)] = ttest(x,y,'Tail','left');
            end
        end
          

    end

end
for plot_idx = 1:3
    disp(measures{plot_idx});
    disp(squeeze(pval_table(:,plot_idx,:)));
end
