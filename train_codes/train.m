%% Written by Seyedeh-Zahra Mousavi
% -Training the energy function parameters using MCS global optimization.
% -Download the MCS library and its dependencies from https://www.mat.univie.ac.at/~neum/software/mcs/.
% -Download Berkeley Contour Detection and Image Segmentation Resources from https://www2.eecs.berkeley.edu/Research/Projects/CS/vision/grouping/BSR/BSR_full.tgz and build it. 
%    It contains the BSDS500 dataset and also evaluation codes.
% -Run your soft edge detection method on training data and save the outputs as .mat format in a directory named softmap_directory.
%    We put an example folder that contains some photos.
% -Consider an initial threshold and convert soft outputs to binary. After that compute the direction map for each binary image and save them as .mat format in a directory named dirmap_directory. 
%    You can use skeletonOrientation.m function that gets a binary image and returns orientation.
%    We put an example folder that contains direction images.
%%
clear all
%%
clear; clear mex; clear global; 
format compact;format long
%% set these paths:
addpath('../maxflow');
addpath('../utils');
addpath('mcs/gls');
addpath('mcs/minq5');
addpath('mcs');
addpath('bench/benchmarks');
%% Set these four paths:
imgDir = 'images'; % Training images directory
gtDir = 'GT';     % Ground truth images directory
softmap_directory='softmap'; % Soft images directory
dirmap_directory='dirmap';   % Direction images directory
%% Contour integration hyperparameters
th0=0.09;
n=9;
%% Maximum Iterations 
maxIter=400; 
%% Defining some global variables that save the optimization variables and their objective value.
global xs;
xs=zeros(11,maxIter);
global c;
c=0;
global fs;
fs=zeros(maxIter,1);
global best_F;
best_F=0;
global best_x;
best_x=0;
%% Computing auxiliary matrices: These matrices are used for the matrix implementation of energy functions.
%    These matrices need to compute just once.
[angle ] =compute_angle_matrix( n  );
[ distance ] = compute_distance_matrix( n );
[ B1,B2 ] = compute_offsets(n);
%% Necessary data that should be passed to Objective function. 
Data=cell(6,1);
Data{1,1}=th0;
Data{2,1}=n;
Data{3,1}=angle;
Data{4,1}=distance;
Data{5,1}=B1;
Data{6,1}=B2;
Data{7,1}=imgDir;
Data{8,1}=gtDir;
Data{9,1}=softmap_directory;
Data{10,1}=dirmap_directory;
%% Optimization parameters (https://www.mat.univie.ac.at/~neum/software/mcs/)
% [u,v]       	box in which the optimization is carried out (u, v 
%             	n-vectors)
% prt		print level
% 		prt = 0: no printing
% 		prt = 1: # sweep, minimal nonempty level, # f-calls, 
% 		best point and function value (default)
% 		prt > 1: only meaningful for test functions with known
% 		global minimizers
% 		in addition levels and function values of boxes 
% 		containing the global minimizers of a test function
% smax        	number of levels (default: 5*n+10)
% nf         	maximum number of function evaluations (default: 50*n^2)
% stop         	stop(1) in ]0,1[:  relative error with which the known 
%		 global minimum of a test function should be found
%		 stop(2) = fglob known global minimum of a test function
%		 stop(3) = safeguard parameter for absolutely small 
%		 fglob
%		stop(1) >= 1: the program stops if the best function
%		 value has not been improved for stop(1) sweeps
%		stop(1) = 0: the user can specify a function value that
%		 should be reached
%                stop(2) = function value that is to be achieved
%             	(default: stop = 3*n)
% iinit       	parameter defining the initialization list
%             	= 0        corners and midpoint (default for finite u,v)
%             	= 1        safeguarded version *default otherwise)
% 		= 2        5u/6 + v/6, u/6 + 5v/6 and midpoint
%		= 3        initialization list with line searches
%             	otherwise  self-defined init. list (to be stored in 
%			   init0.m)
%		for a self-defined initialization list, the user should
% 		provide an m-script file init0.m containing a matrix x0 
%		with n rows and at least 3 columns and two n-vectors l 
%		and L 
%		the ith column of x0 contains the initialization list
%		values for the ith coordinate, their number is L(i), and
%		x0(i,l(i)) is the ith coordinate of the initial point
% local		local = 0: no local search
%		otherwise: maximal number of steps in local search
u=[0.2 1.5 0.5 1 0   1 1.5 0.75  1  0.5  0.09]';
v=[0.7 6.5 3.5 5 0.5 2 3.5 1.5   4  1.5  0.14]';
n = length(u);		% problem dimension
smax = 5*n+10;		
prt=1;
nf =maxIter;
stop(1) = 3*n+10;		
iinit = 0;
local=0;
%% Runing the Optimization
[xbest,fbest,xmin,fmi,ncall,ncloc]=...
  mcs(@Objective_function,Data,u,v,prt,smax,nf,stop,iinit,local);
