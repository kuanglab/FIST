clear all;clc;close all;
data_bag = {'HBA1','HBA2','HH','HLN','MKC','MBC','MB1P','MB2P','MB1A','MB2A'};
mksize = 12;
markerbag = {'p','s','o','d','^'};
mesures = {'MAE','MAPE','R^2'};
color = get(gca,'ColorOrder');
close all;
for plot_idx = 1:3
    
    numcell = cell(10,1);
    groupcell = cell(10,1);

    for nameid=1:10
        %% FIST
        vec_mae = [];
        vec_mape = [];
        vec_r2 = [];

        for fold=1:5
            fname=['FIST_10xslice_',data_bag{nameid},'_fold',num2str(fold),'.mat'];
            load(['FIST_res/slice_wise_10x/',fname]);    
            x = r2res{1};
            vec_mae = [vec_mae;maeres{1}(~isinf(x))];
            vec_mape = [vec_mape;maperes{1}(~isinf(x))];
            vec_r2 = [vec_r2;r2res{1}(~isinf(x))];
        end
        Data_mae{1} = vec_mae;
        Data_mape{1} = vec_mape;
        Data_r2{1} = vec_r2;


        %% GWNMF
        vec_mae = [];
        vec_mape = [];
        vec_r2 = [];

        for fold=1:5
            fname=['GWNMF_10xslice_',data_bag{nameid},'_fold',num2str(fold),'.mat'];
            load(['GWNMF_res/slice_wise_10x/',fname]);    
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
            fname = ['Spatial1NN_10xslice_',data_bag{nameid},'_fold',num2str(fold),'.mat'];
            load(['SpatialNN_res/slice_wise_10x/',fname]);    
            x = r2res{1};
            vec_mae = [vec_mae;maeres{1}(~isinf(x))];
            vec_mape = [vec_mape;maperes{1}(~isinf(x))];
            vec_r2 = [vec_r2;r2res{1}(~isinf(x))];
        end
        Data_mae{3} = vec_mae;
        Data_mape{3} = vec_mape;
        Data_r2{3} = vec_r2;

        %% ZIFA
        vec_mae = [];
        vec_mape = [];
        vec_r2 = [];

        for fold=1:5
            fname = ['ZIFA_10xslice_',data_bag{nameid},'_fold',num2str(fold),'.mat'];
            load(['ZIFA_res/slice_wise_10x/',fname]);    
            x = r2res{1};
            vec_mae = [vec_mae;maeres{1}(~isinf(x))];
            vec_mape = [vec_mape;maperes{1}(~isinf(x))];
            vec_r2 = [vec_r2;r2res{1}(~isinf(x))];
        end
        Data_mae{4} = vec_mae;
        Data_mape{4} = vec_mape;
        Data_r2{4} = vec_r2;

        %% REMAP
        vec_mae = [];
        vec_mape = [];
        vec_r2 = [];

        for fold=1:5
            fname=['REMAP_10xslice_',data_bag{nameid},'_fold',num2str(fold),'.mat'];
            load(['REMAP_res/slice_wise_10x/',fname]);    
            x = r2res{1};
            vec_mae = [vec_mae;maeres{1}(~isinf(x))];
            vec_mape = [vec_mape;maperes{1}(~isinf(x))];
            vec_r2 = [vec_r2;r2res{1}(~isinf(x))];
        end
        Data_mae{5} = vec_mae;
        Data_mape{5} = vec_mape;
        Data_r2{5} = vec_r2;

        Data_box = {Data_mae,Data_mape,Data_r2};
        Data = Data_box{plot_idx};

        for method = 1:5
            numcell{nameid} = [numcell{nameid}; Data{method}];
            groupcell{nameid} = [groupcell{nameid}; method*ones(size(Data{method}))];
        end

    end
    
    for nameid = 1:10
        figure;
        hold on
        h = boxplot(numcell{nameid},groupcell{nameid}); % old version: h = boxplot([allData{:}],group);
        xCenter = 1:numel(Data); 
        spread = 0.7; % 0=no spread; 0.5=random spread within box bounds (can be any value)
        for i = 1:numel(Data)
            s = scatter(rand(size(Data{i}))*spread -(spread/2) + xCenter(i), Data{i},'filled','SizeData',1);
            alpha(s,.5)
        end
        ylabel(mesures{plot_idx}, 'fontsize', 20);
        color = get(gca,'ColorOrder');
        mymap = color(1:length(Data),:);
        colormap(mymap);
        set(h, 'linewidth' ,1.5)
        set(gca,'XTickLabel', {'FIST'; 'GWNMF'; 'Spatial-NN'; 'ZIFA'; 'REMAP'},'fontsize', 15);    
        title(data_bag{nameid},'fontsize',20);
        hold off;
        grid on;box on;
        saveas(gca, [data_bag{nameid},'_',mesures{plot_idx},'.eps'],'epsc');
        close all;
        
    end
end
