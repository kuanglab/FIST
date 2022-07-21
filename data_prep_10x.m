
% V: data tensor 
% W: spatial chain graphs and PPI network
% rank_k: CPD rank
function [V,W,rank_k] = data_prep_10x(dataName,PPIName data_path, utils_path)

% load data tensor
load([data_path,dataName,'_tensor.mat']); 

load([data_path,PPIName]);

% load gene ids
genes = importdata([data_path,dataName,'_gene.csv']);
genes = genes(2:end);
for i = 1:size(genes)
    tmp = split(genes{i},',');
    genes{i} = tmp{2};
end

cd(utils_path);
vals = V.vals; 
vals(vals==2) = 1; % set to zeros if UMI counts < 3 (this step can be ignored for high-quality data)
V = sptensor(V.subs,log(vals),V.size); % log normalization

% eliminate boundaries
Z = double(tenmat(V,1));
ind1 = find(sum(Z,2) ~= 0);
Z = double(tenmat(V,2));
ind2 = find(sum(Z,2) ~= 0);
V  = V(ind1,ind2,:);

% to compare with ZIFA, we need filter out the low-density genes
% this step is simply for performance comparisons
Z = double(tenmat(V,3));
Z(Z>0)=1;
density = sum(Z,2)/size(Z,2);
ind3 = find(density>0.1);
V  = V(:,:,ind3);
n = [size(V,1),size(V,2),size(V,3)];
genes = genes(ind3);

W = cell(3,1);
% build spatial graphs
for netid = 1:2 
    W{netid} = diag(ones(n(netid)-1,1),-1) + diag(ones(n(netid)-1,1),1);
end

% build PPI network
W{3} = zeros(n(3),n(3));

if exist HSA_BIOGRID 
    [ia,ib] = ismember(genes,HSA_UNIQ_BIOGRID_GENE);
    W{3}(ia,ia) = HSA_BIOGRID(ib(ib>0),ib(ib>0));           
elseif exist MUS_BIOGRID
    [ia,ib] = ismember(genes,MUS_GENE);
    W{3}(ia,ia) = MUS_BIOGRID(ib(ib>0),ib(ib>0));
else
    %only human and mouse datasets are supported
end

Tmat = tenmat(V,3);
data = Tmat.data;
[~, ~, pcvars] = pca(data'); 
v= cumsum(pcvars./sum(pcvars) * 100);
ind = find(v>=60);
rank_k = ind(1);
if rank_k > 300
    rank_k = 300;
elseif rank_k < 200
    rank_k = 200;
end

end
