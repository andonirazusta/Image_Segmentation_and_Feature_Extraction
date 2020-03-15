function [g,T]= Otsu_Thresholding(f)
num_bins = 256;
hist = imhist(f,num_bins); % compute histogram

p = hist / sum(hist);
omega = cumsum(p); % compute the cumulative
mu = cumsum(p .* (1:num_bins)');
mu_t = mu(end);

sigma = (mu_t * omega - mu).^2 ./ (omega .* (1 - omega));

% find the maximum value
maxval = max(sigma);
idx = mean(find(sigma == maxval)); 
T = (idx - 1) / (num_bins - 1);

g = zeros(size(f));
% create the binary image
g(find(f>=round(255*T))) = 255;
g(find(f<round(255*T))) = 0;

