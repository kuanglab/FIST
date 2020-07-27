function [V,W,n] = data_prep(dataName, data_path, utils_path)

cd(data_path);
load([dataName,'_tensor.mat']); % load data tensor
load('MUS_PPI.mat'); % load PPI network
genes = importdata([dataName,'_gene.csv']); % load gene ids
genes = genes(2:end);
for i = 1:size(genes)
    tmp = split(genes{i},',');
    genes{i} = tmp{2};
end

cd(utils_path);
vals = V.vals; 
vals(vals==2) = 1; 
V = sptensor(V.subs,log(vals),V.size);

Z = double(tenmat(V,1));
ind1 = find(sum(Z,2) ~= 0);
Z = double(tenmat(V,2));
ind2 = find(sum(Z,2) ~= 0);
V  = V(ind1,ind2,:);
Z = double(tenmat(V,3));
Z(Z>0)=1;
density = sum(Z,2)/size(Z,2);
ind3 = find(density>0.1); % to compare with ZIFA, we need filter the low-density genes
V  = V(:,:,ind3);
n = [size(V,1),size(V,2),size(V,3)];
genes = genes(ind3);


W = cell(3,1);
for netid = 1:2 % build spatial graphs
    W{netid} = diag(ones(n(netid)-1,1),-1) + diag(ones(n(netid)-1,1),1);
end
W{3} = zeros(n(3),n(3));

[ia,ib] = ismember(genes,MUS_GENE);
W{3}(ia,ia) = MUS_BIOGRID(ib(ib>0),ib(ib>0));

end