clear all;clc;close all
res_path = 'FIST_res/fiber_wise_10x/';
lambdavec = [0,10^-1,1];
data_bag = {'HBA1','HBA2','HH','HLN','MKC','MBC','MB1P','MB2P','MB1A','MB2A'};
plotcum = 0;
measures = {'MAE','MAPE','R^2'};
fig = figure;
for plot_idx = 1:3
for nameid = 1:10
for lambdai = 1:length(lambdavec)
vec_mae = [];
vec_mape = [];
vec_r2 = [];

for fold=1:5
    fname=[res_path,'FIST_10xfiber_',data_bag{nameid},'_fold',num2str(fold),'.mat'];
    load(fname); 
    maeres = maeres([1,3,4]);
    maperes = maperes([1,3,4]);
    r2res = r2res([1,3,4]);
    x = r2res{lambdai};
    vec_mae = [vec_mae;maeres{lambdai}(~isinf(x))];
    vec_mape = [vec_mape;maperes{lambdai}(~isinf(x))];
    vec_r2 = [vec_r2;r2res{lambdai}(~isinf(x))];
end
Data_mae{lambdai} = vec_mae;
Data_mape{lambdai} = vec_mape;
Data_r2{lambdai} = vec_r2;
end

Data_box = {Data_mae,Data_mape,Data_r2};

xvec = lambdavec;
mksize = 10;
lnwdz = 2;


plotcum = plotcum+1;
subplot(3,10,plotcum);
meanvec = zeros(1,length(lambdavec));
tmp_data = Data_box{plot_idx};
for lambdai = 1:length(lambdavec)
    tmp = tmp_data{lambdai};
    meanvec(lambdai) = mean(tmp);
end

semilogx(xvec+.1,meanvec, '^r-','MarkerSize',mksize,'linewidth',lnwdz);
xticks(xvec+.1);
set(gca,'XTickLabel',{0,0.1,1});
grid on;box on;
if nameid == 1
    ylabel(measures{plot_idx},'Fontsize',20);
end
if plot_idx == 1
    title(data_bag{nameid},'Fontsize',15);
end
end
end

han=axes(fig,'visible','off'); 
han.XLabel.Visible='on';
xlabel(han, 'network hyper-parameter \lambda','Fontsize',20);
