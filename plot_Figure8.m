clear all;clc;close all;
Namebag = {'Replicate 1','Replicate 2','Replicate 3'};
mesures = {'MAE','MAPE','R^2'};
figure;
plotcum = 0;
for plot_idx = 1:3

    for nameid = 1:3

        plotcum  = plotcum+1;
        subplot(3,3,plotcum);

        vec_mae = [];
        vec_mape = [];
        vec_r2 = [];

        for fold=1:5
            fname=['FIST_res/fiber_wise_replicates/FIST_replicates_fiber_',Namebag{nameid},'_fold',num2str(fold),'.mat'];
            load(fname);    
            x = r2res{2};
            vec_mae = [vec_mae;maeres{2}(~isinf(x))];
            vec_mape = [vec_mape;maperes{2}(~isinf(x))];
            vec_r2 = [vec_r2;r2res{2}(~isinf(x))];
        end
        Data_mae{1} = vec_mae;
        Data_mape{1} = vec_mape;
        Data_r2{1} = vec_r2;


        %% GWNMF
        vec_mae = [];
        vec_mape = [];
        vec_r2 = [];

        for fold=1:5
            fname=['GWNMF_res/fiber_wise_replicates/GWNMF_replicates_fiber_',Namebag{nameid},'_fold',num2str(fold),'.mat'];
            load(fname);    
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
            fname=['SpatialNN_res/fiber_wise_replicates/spatial1NN_replicates_fiber_',Namebag{nameid},'_fold',num2str(fold),'.mat'];
            load(fname);    
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
            fname=['REMAP_res/fiber_wise_replicates/REMAP_replicates_fiber_',Namebag{nameid},'_fold',num2str(fold),'.mat'];
            load(fname);    
            x = r2res{1};
            vec_mae = [vec_mae;maeres{1}(~isinf(x))];
            vec_mape = [vec_mape;maperes{1}(~isinf(x))];
            vec_r2 = [vec_r2;r2res{1}(~isinf(x))];
        end
        Data_mae{4} = vec_mae;
        Data_mape{4} = vec_mape;
        Data_r2{4} = vec_r2;

        for i=1:4
            outlier_idx = Data_mae{i}==max(Data_mae{i});
            Data_mae{i}(outlier_idx) = [];
            outlier_idx = Data_mape{i}==max(Data_mape{i});
            Data_mape{i}(outlier_idx) = [];
            outlier_idx = Data_r2{i}==min(Data_r2{i});
            Data_r2{i}(outlier_idx) = [];
        end
        Data_box{1} = Data_mae;
        Data_box{2} = Data_mape;
        Data_box{3} = Data_r2;


        Data_plot = Data_box{plot_idx};

        group =[];
        for i=1:length(Data_plot)
            group = [group; i*ones(size(Data_plot{i}))];
        end

        hold on
        vec_plot = cell2mat(Data_plot);
        h = boxplot(vec_plot,group,'OutlierSize',1); 
        xCenter = 1:numel(Data_plot); 
        spread = 0.5; % 0=no spread; 0.5=random spread within box bounds (can be any value)
        for i = 1:numel(Data_plot)
            s = scatter(rand(size(Data_plot{i}))*spread -(spread/2) + xCenter(i), Data_plot{i},'filled','SizeData',2);
            alpha(s,0.5)
        end


        if plot_idx == 1
        yticks(round(min(vec_plot(:)),1)-0.4 : 0.4: round(max(vec_plot(:)),1)+0.1);
        elseif plot_idx == 2
            yticks(round(min(vec_plot(:)),1)-0.15 : 0.1: round(max(vec_plot(:)),1)+0.1);
        else
        end
        set(gca,'xtick',[]);

        color = get(gca,'ColorOrder');
        mymap = color(1:length(Data_plot),:);
        colormap(mymap);
        set(h, 'linewidth' ,1)
        grid on;
        box on;
    end
    
end
