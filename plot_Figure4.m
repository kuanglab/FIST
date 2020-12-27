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


    figure;hold on;
    x = 0;
    xvec = [2];
    for p = 1:10
        val = numcell{p};
        ind = groupcell{p};
        if p>=2
        xvec = [xvec,x+1];
        end
        for i=1:5
            x = x+1;
            y = mean(val(ind==i));
            err = std(val(ind==i));
            errorbar(x,y,err,markerbag{i},'MarkerSize',mksize,'linewidth',2,'Color',color(i,:));   
        end
        set(gca,'xtick',[])
        if p<10
        xline(x+3,'--','linewidth',2);
        end
        x = x+5;

    end
    xvec = xvec+2;
    
    if plot_idx == 3
        xticks(xvec);
        xticklabels(data_bag);
        xtickangle(45);
        grid on;
        hold off
        a = get(gca,'XTickLabel');
        set(gca,'XTickLabel',a,'fontsize',20);
    end

    grid on;
    hold off
    ylabel(mesures{plot_idx},'Fontsize',20);
    if plot_idx==1
    legend(fliplr({'REMAP','ZIFA','Spatial-NN','GWNMF','FIST'}),...
        'LineWidth',1,'Orientation' ,'horizontal','Location','northoutside','FontSize',20);
    end
end
