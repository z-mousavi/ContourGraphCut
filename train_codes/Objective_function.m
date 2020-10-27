%% Written by Seyedeh-Zahra Mousavi
% Computing minus average F-Measure for training data.
%%
function [ f ] = Objective_function( Data, x)
%% Temporary directories
pbDir = 'pb_directory';
ResDir = 'result_directory';
if exist(ResDir)>0
    rmdir(ResDir,'s');
end
mkdir(ResDir);
if exist(pbDir)>0
    rmdir(pbDir,'s');
end
mkdir(pbDir);
%%  Global variables that save the optimization variables and their objective value.
global best_F;
global best_x;
global xs;
global fs;
global c;
%%
if x(10)==0
    x(9)=1;
    x(8)=1;
   
end
%% Check if the objective function is computed for the variable before
%  Avoiding extra computation
[ flag,f1 ] = is_computed( x );
if flag==1
    fprintf('x was computed before...\n');
    f=f1;
else
%% Get necessary data 
th0=Data{1,1};
n=Data{2,1};
angle=Data{3,1};
distance=Data{4,1};
B1=Data{5,1};
B2=Data{6,1};
imgDir=Data{7,1};
gtDir=Data{8,1};
softmap_directory=Data{9,1};
dirmap_directory=Data{10,1};
%% Applying contour integration to training soft images.
soft_files=dir(fullfile(softmap_directory,'*.mat*'));
l=length(soft_files);
for i=1:l
    fprintf('Processing image %d...\n',i);
    load([[softmap_directory,'/'],soft_files(i).name]);
    load([[dirmap_directory,'/'],soft_files(i).name]);
    ii=find(dirmap<0);
    dirmap(ii)=pi+dirmap(ii);
    [ A,T,edge_places] = comput_energies_train( x, softmap,th0,angle,distance,B1,B2,n,dirmap);
    [~,labels] = maxflow(A,T);
    [rows, cols]=size(dirmap);
    bw=find(labels==0);
    pb=zeros(rows,cols);
    pb(edge_places(bw))=1;
    f_name=strcat([pbDir,'/'],soft_files(i).name);
    save(f_name,'pb');
end
%% Computing minus average F-Measure for training data.
nthresh =1;
boundaryBench(imgDir, gtDir, pbDir, ResDir, nthresh);
row=dlmread([ResDir,'/eval_bdry.txt']);
AVG_F=row(4);
f=-round(AVG_F,3);
%% Updating global variables
if f<best_F
      best_F=f;
      best_x=x;
end
c=c+1;
xs(:,c)=x;
fs(c)=f;
end
%% Some prints
fprintf('  f is %f...\n',f);
fprintf('  bestF is %f...\n',best_F);


end
