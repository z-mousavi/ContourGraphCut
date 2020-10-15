# Matlab implementation of Contour Integration using Graph-Cut and Non-Classical Receptive Field

## Overview
We proposed a graph-based framework that gets the soft-value of other methods as its input and creates more meaningful contours. Inspired by the concept of non-classical receptive fields in the primary visual cortex, we considered important factors such as connectivity, smoothness, and length of the contour beside the soft-values.

![alt tag](https://github.com/z-mousavi/Contour_GraphCut/blob/main/Graphical_abstract.PNG)

## How to use

### Test
* Download the maxflow folder from this repository and make it. (The Original reference is: https://www.mathworks.com/matlabcentral/fileexchange/21310-maxflow?s_tid=mwa_osa_a)
* The function edge2contour gets the soft edge-map and the parameters and returns the binary contour-map. 
* Run the Gradient_Magnitude_test.m, mPb_test.m and SCG_test.m to see the result of applying our framework on three methods including: Gradient Magnitude, mPb and SCG. The parameters are trained for these three methods. If you require to employ our framework on your soft method, you should train the parameters anew.

### Train
* Download the MCS library and its dependencies from https://www.mat.univie.ac.at/~neum/software/mcs/.
* Download Berkeley Contour Detection and Image Segmentation Resources from https://www2.eecs.berkeley.edu/Research/Projects/CS/vision/grouping/BSR/BSR_full.tgz and build it. It contains the BSDS500 dataset and also evaluation codes.
* Run your soft edge detection method on training data and save the outputs as .mat format in a directory named softmap_directory. Set the path of softmap_directory in Objective_fuction.m.
* Consider an initial threshold and convert soft outputs to binary. After that compute the direction map for each binary image and save them as .mat format in a directory named dirmap_directory. Keep in mind that the initial threshold should not be too high. Set the path of dirmap_directory in Objective_fuction.m. 
* Set the path of training images directory in Objective_fuction.m.
* Set the path of ground truth images directory in Objective_fuction.m.




