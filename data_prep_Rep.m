
% V: data tensor 
% W: spatial chain graphs and PPI network
% n: tensor dimensions
function [V,W,rank_k] = data_prep_Rep(nameid, data_path, utils_path)

% load data tensor
load([data_path,'Rep',num2str(nameid),'_MOB_rpkm_matrix-tensor.mat']); 

% load PPI network
load([data_path,'MUS_PPI.mat']);

% load gene ids
genes = importdata([data_path,'Rep',num2str(nameid),'_gene_names.csv']);

cd(utils_path);
V = sptensor(V.subs,V.vals,V.size);
% eliminate boundaries
Z = double(tenmat(V,1));
ind1 = find(sum(Z,2) ~= 0);
Z = double(tenmat(V,2));
ind2 = find(sum(Z,2) ~= 0);
Z = double(tenmat(V,3));
ind3 = find(sum(Z,2) ~= 0);
V  = V(ind1,ind2,ind3);
n = [size(V,1),size(V,2),size(V,3)];
genes = genes(ind3);

W = cell(3,1);
% build spatial graphs
for netid = 1:2 
    W{netid} = diag(ones(n(netid)-1,1),-1) + diag(ones(n(netid)-1,1),1);
end

% build PPI network
W{3} = zeros(n(3),n(3));


[ia,ib] = ismember(genes,MUS_GENE);
W{3}(ia,ia) = MUS_BIOGRID(ib(ib>0),ib(ib>0));

%% determining the CPD rank ...
Tmat = tenmat(V,3);
data = Tmat.data;
[~, ~, pcvars] = pca(data'); 
v= cumsum(pcvars./sum(pcvars) * 100);
ind = find(v>=60);
rank_k = ind(1);
end