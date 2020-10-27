%% Written by Seyedeh-Zahra Mousavi
%  -Applying the contour integration method to the soft output of the mPb method. 
%  -The mPb method reference paper: Contour detection and hierarchical image segmentation.
%  -Parameters are trained pursuant to the mPb method.
%  -Soft edge-map is computed using: https://www2.eecs.berkeley.edu/Research/Projects/CS/vision/grouping/resources.html 
%  -The test image is selected from the test folder of BSDS500 dataset.
% 
%% 
clear all
p1=genpath('maxflow');
addpath(p1);
p2=genpath('utils');
addpath(p2);
%% parameters are trained pursuant to mPb Method
%mPb Method : Contour detection and hierarchical image segmentation
th0=0.1;
n=9;
theta=[   0.415000000000000
   2.500000000000000
   0.950000000000000
   2.500000000000000
   5.500000000000000
   1.000000000000000
   3.710000000000000
   1.250000000000000
   0.500000000000000
   1.309016994374947];
%% Loading soft edge-map (computed using: https://www2.eecs.berkeley.edu/Research/Projects/CS/vision/grouping/resources.html)
load('mPb/41085_soft.mat');
softmap=z;
%% computing binary contour-map
[contour_map] =edge2contour(softmap,th0,n,theta);
%% Loading original image
img=imread('mPb/41085.jpg');
%% computing binary map by applying the optimal threshold 
best_th=0.2583;  % computed for this image (computed using: https://www2.eecs.berkeley.edu/Research/Projects/CS/vision/grouping/segbench/code/)
BW=zeros(size(softmap));
BW(softmap>best_th)=1;
Opt_th_map=logical(BW);
%% Loading Ground truth
load('mPb/41085_GT.mat');
GT=zeros(size(softmap));
for i = 1:numel(groundTruth)
    GT=GT|double(groundTruth{i}.Boundaries);
end
%% plots
figure(1)
subplot(1,3,1)
imshow(img);
title('original image');
subplot(1,3,2)
imshow(GT);
title('Ground truth');
subplot(1,3,3)
imshow(softmap);
title('Soft output');
figure(2)
subplot(1,2,1)
imshow(contour_map);
title('Proposed method');
subplot(1,2,2)
imshow(Opt_th_map);
title('Use best threshold');

