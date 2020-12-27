clear all;clc;close all
Namebag = {'Replicate 1','Replicate 2','Replicate 3'};
measures = {'MAE','MAPE','R^2'};
lambdavec = [10^-2,10^-1,1];
plotcum = 0;
fig = figure;
for plot_idx = 1:3
for nameid = 1:3


for lambdai = 1:length(lambdavec)
vec_mae = [];
vec_mape = [];
vec_r2 = [];

for fold=1:5
    fname=['FIST_res/fiber_wise_replicates/FIST_replicates_fiber_',Namebag{nameid},'_fold',num2str(fold),'.mat'];
    load(fname);
    x = r2res{lambdai};
    vec_mae = [vec_mae;maeres{lambdai}(~isinf(x))];
    vec_mape = [vec_mape;maperes{lambdai}(~isinf(x))];
    vec_r2 = [vec_r2;r2res{lambdai}(~isinf(x))];
end
Data_mae{lambdai} = vec_mae;
Data_mape{lambdai} = vec_mape;
Data_r2{lambdai} = vec_r2;
end


for i=1:length(Data_mae)
    outlier_idx = Data_mae{i}==max(Data_mae{i});
    Data_mae{i}(outlier_idx) = [];
    outlier_idx = Data_mape{i}==max(Data_mape{i});
    Data_mape{i}(outlier_idx) = [];
    outlier_idx = Data_r2{i}==min(Data_r2{i});
    Data_r2{i}(outlier_idx) = [];
end
Data_box = {Data_mae,Data_mape,Data_r2};

xvec = lambdavec;
mksize = 10;
lnwdz = 2;


plotcum = plotcum+1;
subplot(3,3,plotcum);
meanvec = zeros(1,length(lambdavec));
tmp_data = Data_box{plot_idx};
for lambdai = 1:length(lambdavec)
    tmp = tmp_data{lambdai};
    meanvec(lambdai) = mean(tmp);
end
semilogx(xvec,meanvec, '^r-','MarkerSize',mksize,'linewidth',lnwdz);
xticks(xvec);
grid on;box on;
if plot_idx ==1
    title(['Replicate ',num2str(nameid)],'Fontsize',15);
end
if nameid ==1
    ylabel(measures{plot_idx},'Fontsize',20);
end


han=axes(fig,'visible','off'); 
han.XLabel.Visible='on';
xlabel(han,'network hypter-parameter \lambda','Fontsize',20);

end
end