# Matlab implementation of Contour Integration using Graph-Cut and Non-Classical Receptive Field

## Overview
We proposed a graph-based framework that gets the soft-value of other methods as its input and creates more meaningful contours. Inspired by the concept of non-classical receptive fields in the primary visual cortex, we considered important factors such as connectivity, smoothness, and length of the contour beside the soft-values.

![alt tag](https://github.com/z-mousavi/Contour_GraphCut/blob/main/Graphical_abstract.PNG)

## How to use
### Dependencies
* Download the maxflow folder from this repository and make it. (The Original reference is: https://www.mathworks.com/matlabcentral/fileexchange/21310-maxflow?s_tid=mwa_osa_a)
* Download the MCS library and its dependencies from https://www.mat.univie.ac.at/~neum/software/mcs/.
* Download Berkeley Contour Detection and Image Segmentation Resources from https://www2.eecs.berkeley.edu/Research/Projects/CS/vision/grouping/BSR/BSR_full.tgz and build it. It contains the BSDS500 dataset and also evaluation codes.
### Test
