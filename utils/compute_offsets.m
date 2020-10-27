%% Written by Seyedeh-Zahra Mousavi
% -B1 and B2 are auxiliary matrices that help us to compute pairwise energies.
% -B1 and B2 contain neighborhood offsets.
%%
function [ B1,B2 ] = compute_offsets( n )
t2=ones(1,n*n);
t1=cumsum(t2);
t=reshape(t1,[n n]);
B1=zeros(n*n,4);
B2=zeros(n*n,4);
global n_index;
for i=1:n*n
    n_index=i;
    tt = nlfilter(t, [n n], @fun); 
    index=find(tt>0);
    k1=index(1);
    k2=index(end);
    [i1, j1]=ind2sub([n n],k1);
    [i2, j2]=ind2sub([n n],k2);
    B1(i,1)=i1-1;
    B1(i,2)=j1-1;
    B1(i,3)=n-i2;
    B1(i,4)=n-j2;
    k1=tt(index(1));
    k2=tt(index(end));
    [i1, j1]=ind2sub([n n],k1);
    [i2, j2]=ind2sub([n n],k2);
    B2(i,1)=i1-1;
    B2(i,2)=j1-1;
    B2(i,3)=n-i2;
    B2(i,4)=n-j2;  
end


end

