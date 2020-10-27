%% Written by Seyedeh-Zahra Mousavi
% -This function computes unary and pairwise energies.
% -In order to reduce time complexity the unary and pairwise energies are computed in matrix form.
%   We have only an n*n loop. The parameter n is small and determines the size of the NoN-classical Receptive Field (Markov blanket). 
%   An n×n square centered at the position of each edge segment.
%   n should be odd.
% -The parameters:
%    -x: The parameters of energy functions.
%    -n: The size of the NoN-classical Receptive Field (Markov blanket).
%    -soft: The Soft edge image.
%    -dir: The image of pixels directions.
%    -th0: The initial threshold.
%      Pixels that are above the threshold, are considered as representative of probable contours.
%
%%
function [ AA,TT,edge_places,c1] = comput_energies( x,soft,th0,n,dir)
%% Computing auxiliary matrices: These matrices are used for the matrix implementation of energy functions.
[angle ] =compute_angle_matrix( n  );
[ distance ] = compute_distance_matrix( n );
[ B1,B2 ] = compute_offsets(n);
%%
BW=zeros(size(soft));
BW(soft>th0)=1;
BW=logical(BW);
%%
n_p=sum(BW(:));
[rows,cols]=size(dir);
n_n=numel(angle)-1;
t2=BW(:);
t1=cumsum(t2);
t=reshape(t1,[rows cols]).*BW;
Ap=cell(1,1);
indexp=cell(2,1);
Ap{1,1}=zeros(n_n*n_p,1);
indexp{1,1}=zeros(n_n*n_p,1);
indexp{2,1}=zeros(n_n*n_p,1);
mid=sub2ind(size(angle), ceil(n/2),  ceil(n/2));
c1=1;
ttj=zeros(size(dir));
ttw=zeros(size(dir));
soft=soft.*BW;
softp=mat2gray(soft);
for i=1:numel(angle)  % main loop
     if i~=mid
         b=angle(i);
         dis=distance(i);
         dir1=dir(1+B1(i,1):rows-B1(i,3),1+B1(i,2):cols-B1(i,4));
         dir2=dir(1+B2(i,1):rows-B2(i,3),1+B2(i,2):cols-B2(i,4));
         soft1=softp(1+B1(i,1):rows-B1(i,3),1+B1(i,2):cols-B1(i,4));
         soft2=softp(1+B2(i,1):rows-B2(i,3),1+B2(i,2):cols-B2(i,4));
         BW1=BW(1+B1(i,1):rows-B1(i,3),1+B1(i,2):cols-B1(i,4));
         BW2=BW(1+B2(i,1):rows-B2(i,3),1+B2(i,2):cols-B2(i,4));
         B_index=BW1.*BW2;
         Jp=exp(x(5)*min(abs(cos(dir1-b)),abs(cos(dir2-b)))+x(6)*abs(cos(dir1-dir2))).* B_index;
         Wp=exp(x(5)*max(abs(sin(dir1-b)),abs(sin(dir2-b)))+x(6)*abs(sin(dir1-dir2))).* B_index;
         J=Jp*exp(-dis/x(7));
         W=Wp*exp(-dis/x(7));
         s1=t(1+B1(i,1):rows-B1(i,3),1+B1(i,2):cols-B1(i,4));
         s2=t(1+B2(i,1):rows-B2(i,3),1+B2(i,2):cols-B2(i,4));
         index1=s1(B_index==1);
         index2=s2(B_index==1);
         ttj(1+B1(i,1):rows-B1(i,3),1+B1(i,2):cols-B1(i,4))=ttj(1+B1(i,1):rows-B1(i,3),1+B1(i,2):cols-B1(i,4))+soft2.*J;
         ttw(1+B1(i,1):rows-B1(i,3),1+B1(i,2):cols-B1(i,4))=ttw(1+B1(i,1):rows-B1(i,3),1+B1(i,2):cols-B1(i,4))+soft2.*W;
         d=abs(soft1-soft2);
         F=exp(-d/x(8));
         A1=x(10)*F*exp(-dis/x(9)).*Jp;
         l=length(index1(:));
         indexp{1,1}(c1:c1+l-1)=index1(:);
         indexp{2,1}(c1:c1+l-1)=index2(:);
         Ap{1,1}(c1:c1+l-1)=A1(B_index==1);
         c1=c1+l;
     end

end
c1=c1-1;
A=Ap{1,1}(1:c1);
index1=indexp{1,1}(1:c1);
index2=indexp{2,1}(1:c1);
nNodes=n_p;
AA=sparse(index1,index2,A,nNodes,nNodes);
ttj=mat2gray(ttj);
ttw=mat2gray(ttw);
zz=x(1)*(1./(exp((x(2)*ttj-x(3)*ttw))+1)) + (1-x(1))*(1./(exp((x(4)*soft-1))+1));
T1=-log(zz);
T2=-log(1-zz);
TT1=T1(BW==1);
TT2=T2(BW==1);
TT=sparse(nNodes,2);
TT(:,1)=reshape(TT1,[nNodes,1]);
TT(:,2)=reshape(TT2,[nNodes,1]);
t2=ones(rows*cols,1);
t1=cumsum(t2);
t=reshape(t1,[rows cols]).*BW;
edge_places=t(BW==1);

end