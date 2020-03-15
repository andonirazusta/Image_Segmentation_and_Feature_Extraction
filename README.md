# Image_Segmentation_and_Feature_Extraction
 This is a project with 4 tasks. Image segmentation and feature extraction techniques are implemented in a MATLAB environment.


## Task 1 – Global Thresholding

The first task of the project consists on writing a program that implements an iterative thresholding. The program will be used to segment a given image. The algorithm method is defined in the next points:
1.	Select an initial estimate for T.
2.	Segment the image using T.
3.	Compute averages of G1 and G2.
4.	Compute the new threshold value Tnew = 0.5*(m1+m2).
5.	Repeat steps 2 thru 4 until the change of T is sufficiently small.


## Task 2 – Otsu’s Thresholding

The objective of the second task of the project is to implement Otsu’s optimum thresholding algorithm from scratch.
Otsu’s algorithm consists on following this procedure:
1.	Compute the normalized histogram of the input image.
2.	Compute the cumulative sums P(k).
3.	Compute the cumulative means m(k).
4.	Compute the global intensity mean mg.
5.	Compute the between-class variance sigma(k).
6.	Obtain the Otsu threshold Kopt as the value of k with maximum sigma.


## Task 3 – Chain Codes

In this part, we are given an image of a circular stroke with specular noise. The objective of the problem is to obtain the Freeman chain code, the first difference of the outer boundary of the largest object, and the integer of minimum magnitude of the code.


## Task 4 – Fourier Descriptors

The last part of this project is about the implementation of the Fourier descriptors. A binary image of a human chromosome will be used. 
After extracting the boundary of the chromosome, the program will compute the Fourier descriptors. Then, using the sequence of Fourier descriptors, the inverse of the Fourier transform will be computed to reconstruct the image using different number of descriptors.
