function A = FIST(T,W,opts)
%% input
% T: input tensor (dim: nx-ny-np)
% W: cell array of graphs
% opts: parameter object
%    - rank_k: tensor CPD rank
%    - lambda: graph hyperparameter
%    - dense_mod: 0 use sparse implementation of FIST, 1 use dense implementation of FIST 
%    - stopcrit: stop training if residual<stopcrit
%    - MaxIters: iterate at most MaxIters iterations
%% output
% A: cell array of three CPD factor matrices learned by FIST

n = size(T); % tensor dimensions
net_num = length(n); 
O_ = sptensor(T.subs,ones(size(T.vals)),n);
if opts.dense_mod == 1 % if Y0 is a dense tensor, then use dense model of FIST
    O_ = tensor(O_);
    T = tensor(T);
end

% graph normalization
D=cell(net_num,1);
for netid = 1:net_num
    W{netid} = W{netid} - diag(diag(W{netid}));
    d = sum(W{netid},2);
    d(d~=0) = (d(d~=0)).^-(0.5);
    W{netid} = W{netid}.*d;
    W{netid}=d'.*W{netid};
    D{netid}=diag(sum(W{netid},2));
end

% initialization
A=cell(net_num,1);
X = A;
Y = A;
ZW = A;
ZD = A;
MW = A;
MD = A;
for netid=1:net_num
    rng(0);
    A{netid} = rand(n(netid),opts.rank);  
    X{netid} = A{netid}'*A{netid};
    Y{netid} = sum(A{netid},1)'*sum(A{netid},1);
    ZW{netid} = W{netid}*A{netid};
    ZD{netid} = diag(D{netid}).*A{netid};
    MW{netid} = A{netid}'*ZW{netid};
    MD{netid} = A{netid}'*ZD{netid};
end

% training
for iter=1:opts.MaxIters
    % update factor matrix 1
    Aold = A;
    num = mttkrp(T,A,1);
    Y_hat = ktensor(A).*O_;
    denom = mttkrp(Y_hat,A,1);
    num_kronsum=A{1}*(X{3}.*MW{2}+MW{3}.*X{2})+ZW{1}*(X{3}.*X{2});
    denom_kronsum=A{1}*(X{3}.*MD{2}+MD{3}.*X{2})+ZD{1}*(X{3}.*X{2});
    num=num+opts.lambda*num_kronsum+10^-10;
    denom=denom+opts.lambda*denom_kronsum+10^-10;
    A{1}=A{1}.*(num./denom);


    % update factor matrix 2
    X{1}=A{1}'*A{1};
    Y{1}=sum(A{1},1)'*sum(A{1},1);
    ZW{1}=W{1}*A{1};
    MW{1}=A{1}'*ZW{1};
    ZD{1}=diag(D{1}).*A{1};
    MD{1}=A{1}'*ZD{1};
    num = mttkrp(T,A,2);
    Y_hat = ktensor(A).*O_;
    denom = mttkrp(Y_hat,A,2);      
    num_kronsum=A{2}*(X{3}.*MW{1}+MW{3}.*X{1})+ZW{2}*(X{3}.*X{1});
    denom_kronsum=A{2}*(X{3}.*MD{1}+MD{3}.*X{1})+ZD{2}*(X{3}.*X{1});
    num=num+opts.lambda*num_kronsum+10^-10;
    denom=denom+opts.lambda*denom_kronsum+10^-10;
    A{2}=A{2}.*(num./denom);


    % update factor matrix 3
    X{2}=A{2}'*A{2};
    Y{2}=sum(A{2},1)'*sum(A{2},1);
    ZW{2}=W{2}*A{2};
    ZD{2}=diag(D{2}).*A{2};
    MW{2}=A{2}'*ZW{2};
    MD{2}=A{2}'*ZD{2};
    num = mttkrp(T,A,3);
    Y_hat = ktensor(A).*O_;
    denom = mttkrp(Y_hat,A,3);
    num_kronsum=A{3}*(X{2}.*MW{1}+MW{2}.*X{1})+ZW{3}*(X{2}.*X{1});
    denom_kronsum=A{3}*(X{2}.*MD{1}+MD{2}.*X{1})+ZD{3}*(X{2}.*X{1});
    num=num+opts.lambda*num_kronsum+10^-10;
    denom=denom+opts.lambda*denom_kronsum+10^-10;
    A{3}=A{3}.*(num./denom);


    X{3}=A{3}'*A{3};
    Y{3}=sum(A{3},1)'*sum(A{3},1);
    ZW{3}=W{3}*A{3};
    ZD{3}=diag(D{3}).*A{3};
    MW{3}=A{3}'*ZW{3};
    MD{3}=A{3}'*ZD{3};


    res = compute_res(A,Aold);    
    disp(['FIST traning...residual: ',num2str(res)]);
    disp(['FIST traning...iteration: ',num2str(iter)]);
    if res<opts.stopcrit
        break;
    end

end



end



function res = compute_res(Q,Qold)
% compute residual
res_num = 0;
res_denom = 0;
for i = 1:length(Q)
    res_num = res_num + sum(sum((Q{i}-Qold{i}).^2));
    res_denom = res_denom + sum(sum(Qold{i}.^2));
end
res=sqrt(res_num/res_denom);
end



