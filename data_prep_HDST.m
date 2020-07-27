function [V,W,n] = data_prep_HDST(dataName, data_path, utils_path)

cd(data_path);
load([dataName,'_tensor.mat']); % load data tensor
load('MUS_PPI.mat'); % load PPI network
genes = importdata([dataName,'_gene.csv']); % load gene ids

cd(utils_path);
vals = V.vals; 
vals(vals==2) = 1; 
V = sptensor(V.subs,log(vals),V.size);
n = [size(V,1),size(V,2),size(V,3)];

W = cell(3,1);
for netid = 1:2 % build spatial graphs
    W{netid} = diag(ones(n(netid)-1,1),-1) + diag(ones(n(netid)-1,1),1);
end
W{3} = zeros(n(3),n(3));

[ia,ib] = ismember(genes,MUS_GENE);
W{3}(ia,ia) = MUS_BIOGRID(ib(ib>0),ib(ib>0));

end