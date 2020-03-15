clear all
clc
%% Ex 1
f1 = imread('noisy_fingerprint.tif');
[g1,T1] = AutoThresholding(f1);
subplot(1,2,1), imshow(f1)
title('Raw Image')
subplot(1,2,2), imshow(g1)
title('Auto Thresholding')

%% Ex 2
f2 = imread('polymersomes.tif');

[g2,T21] = Otsu_Thresholding(f2);
% [g2_1,T22] = AutoThresholding(f2);
figure()
subplot(1,2,1), imshow(f2)
title('Raw Image')
subplot(1,2,2), imshow(g2)
title('Otsu Thresholding') 

% figure()
% subplot(1,2,1), imshow(f2)
% title('Raw Image')
% subplot(1,2,2), imshow(im2uint8(g2_1))
% title('Auto Thresholding')

%% Ex3
ChainCode

%% Ex4
