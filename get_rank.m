function rank_k = get_rank(data)
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