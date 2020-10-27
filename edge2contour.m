%% Written by Seyedeh-Zahra Mousavi
% -This function gets the soft edge-map and some parameters and returns the binary contour-map.
% -parameters:
%    -softmap: Input soft-map that is computed by an arbitrary edge detection method.
%    -tho: Initial threshold, The pixels that are higher than this threshold are considered as edge segments.
%    -n: Size of NoN-classical Receptive Field (Markov blanket), An n×n square centered at the position of each edge segment.
%    -theta: Parameter vector of the energy fuctions, Should be tuned according to edge detection method.
% 
% -Following steps is considered:
%     -Detecting initial edge segments by applying a threshold th0 to the soft values.
%     -The orientation of the edge segments are computed from the binary image employing the skeleton orientation method.
%       (http://github.com/tsogkas/matlab-utils/blob/master/skeletonOrientation.m)
%     -Using the edge segments descriptor, position and orientation, we construct a CRF. (Conditional Random Field)
%     -Using the maximum a posteriori inference for computing the best contour integration.
%       (This is solved by Graph-Cut in our framework: https://www.mathworks.com/matlabcentral/fileexchange/21310-maxflow?s_tid=mwa_osa_a)
%%
function [contour_map] =edge2contour(softmap,th0,n,theta)
%% Detecting initial edge segments by applying a threshold th0 on the soft values
BW=zeros(size(softmap));
BW(softmap>th0)=1;
BW=logical(BW);

%% The orientation of the edge segments are computed from the binary image employing the skeleton orientation method
%http://github.com/tsogkas/matlab-utils/blob/master/skeletonOrientation.m
dirmap =skeletonOrientation(BW,5);
dirmap=dirmap*pi/180;
ii=find(dirmap<0);
dirmap(ii)=pi+dirmap(ii);

%% Using the edge segments descriptor, position and orientation, we construct a CRF (Conditional Random Field)
[ A,T,edge_places] = comput_energies( theta, softmap,th0,n,dirmap);

%% Using the maximum a posteriori inference for computing the best contour integration. 
%This is solved by graph-cut in our framework
[~,labels] = maxflow(A,T);
[rows, cols]=size(dirmap);
bw=find(labels==0);
contour_map=zeros(rows,cols);
contour_map(edge_places(bw))=1;
