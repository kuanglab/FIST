
% V: data tensor 
% W: spatial chain graphs and PPI network
% n: tensor dimensions
function [V,W,n] = data_prep_10x_slice(dataName, data_path, utils_path)

% load data tensor
load([data_path,dataName,'_tensor.mat']); 

% load PPI network
if ismember(dataName,{'HBA1','HBA2','HH','HLN'})
    load([data_path,'HSA_PPI.mat']);
else
    load([data_path,'MUS_PPI.mat']);
end

% load gene ids
genes = importdata([data_path,dataName,'_gene.csv']);
genes = genes(2:end);
for i = 1:size(genes)
    tmp = split(genes{i},',');
    genes{i} = tmp{2};
end

cd(utils_path);
vals = V.vals; 
if ~strcmp(dataName,'HH')
    vals(vals==2) = 1; % set to zeros if UMI counts < 3 (this step can be ignored for high-quality data)
end 
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

if ismember(dataName,{'HBA1','HBA2','HH','HLN'})
    [ia,ib] = ismember(genes,HSA_UNIQ_BIOGRID_GENE);
    W{3}(ia,ia) = HSA_BIOGRID(ib(ib>0),ib(ib>0));           
else
    [ia,ib] = ismember(genes,MUS_GENE);
    W{3}(ia,ia) = MUS_BIOGRID(ib(ib>0),ib(ib>0));
end


end