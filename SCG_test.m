%% Written by Seyedeh-Zahra Mousavi
%  -Applying the contour integration method to the soft output of the SCG method.
%  -The SCG method reference paper: Discriminatively trained sparse code gradients for contour detection.
%  -Parameters are trained pursuant to the SCG method.
%  -Soft edge-map is computed using: https://homes.cs.washington.edu/~xren/  
%  -The test image is selected from the test folder of BSDS500 dataset.
%  
%%
clear all
p1=genpath('maxflow');
addpath(p1);
p2=genpath('utils');
addpath(p2);
%% parameters are trained pursuant to SCG Method 
%SCG Method: Discriminatively trained sparse code gradients for contour detection
th0=0.09;
n=9;
theta=[   0.450000000000000
   4.500000000000000
   1.500000000000000
   3.000000000000000
                   0
   1.500000000000000
   2.500000000000000
   1.125000000000000
   3.000000000000000
   1.000000000000000
   0.09];
%% Loading soft edge-map (computed using: https://homes.cs.washington.edu/~xren/)
load('SCG/102062_soft.mat');
softmap=z;
%% computing binary contour-map
[contour_map] =edge2contour(softmap,th0,n,theta);
%% Loading original image
img=imread('SCG/102062.jpg');
%% computing binary map by applying the optimal threshold 
best_th=0.1240; % computed for this image (computed using: https://www2.eecs.berkeley.edu/Research/Projects/CS/vision/grouping/segbench/code/)
BW=zeros(size(softmap));
BW(softmap>best_th)=1;
Opt_th_map=logical(BW);
%% Loading Ground truth
load('SCG/102062_GT.mat');
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

