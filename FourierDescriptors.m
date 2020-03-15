clear all
f = imread('chromosome.tif');

%% a)
h = ones(9,9)/81;
g = imfilter(f,h);

B = bwboundaries(g);

B1 = B{1}; % Main boundary is chosen
M = size(f,1);
N = size(f,2);
image = bound2im(B1,M,N);
figure()
imshow(image)

%% b)
z= FourierDescriptor(B1);



%% c)

d = size(z,1);
nd1 = round(d / 2);
s1 = abs(ifourierdescp(z,nd1));
image1 = bound2im(s1,M,N);
figure()
imshow(image1)

nd2 = round(d / 100);
s1 = abs(ifourierdescp(z,nd2));
image2 = bound2im(s1,M,N);
figure()
imshow(image2)

%% functions
function s = ifourierdescp(z,nd)
np = length(z);
x = 0:(np-1);
m = ((-1).^x)';
d = round((np - nd)/2); % Round in case nd is odd.
z(1:d) = 0;
z(np - d + 1:np) = 0;
% Compute the inverse and convert back to coordinates.
zz = ifft(z);
s(:, 1) = real(zz);
s(:, 2) = imag(zz);
% Multiply by alternating 1 and -1s to undo the earlier 
% centering.
s(:, 1) = m.*s(:, 1);
s(:, 2) = m.*s(:, 2);
end


function z= FourierDescriptor(s)
[np,nc] = size(s);
if np/2 ~= round(np/2)
    s(end+1,:) = s(end,:);
    np=np+1;
end
x = 0:(np-1);
m = ((-1).^x)';
s(:,1) = m.*s(:,1);
s(:,2) = m.*s(:,2);
s = s(:,1) + i*s(:,2);
z = fft(s);
end

function image = bound2im(b, M, N)
% Check input.
if size(b,2) ~= 2
error('The boundary must be of size np-by-2')
end
% Make sure the coordinates are integers.
b = round(b);
% Defaults.
if nargin == 1
Mmin = min(b(:,1)) - 1;
Nmin = min(b(:,2)) - 1;
H = max(b(:,1)) - min(b(:,1))+ 1; % Height of boundary.
W = max(b(:,2)) - min(b(:,2)) + 1; % Width of boundary.
M = H + Mmin;
N = W + Nmin;
end
% Create the image.
image = false(M,N);
linearIndex = sub2ind([M, N], b(:,1), b(:,2));
image(linearIndex) = 1;
end


function [x, y] = intline(x1, x2, y1, y2)
%INTLINE Integer-coordinate line drawing algorithm.
% [X, Y] = INTLINE(X1, X2, Y1, Y2) computes an
% approximation to the line segment joining (X1, Y1) and
% (X2, Y2) with integer coordinates. X1, X2, Y1, and Y2
% should be integers. INTLINE is reversible; that is,
% INTLINE(X1, X2, Y1, Y2) produces the same results as
% FLIPUD(INTLINE(X2, X1, Y2, Y1)).
dx = abs(x2 - x1);
dy = abs(y2 - y1);
% Check for degenerate case.
if ((dx == 0) & (dy == 0))
x = x1;
y = y1;
return;
end
flip = 0;
if (dx >= dy)
if (x1 > x2)
% Always "draw" from left to right.
t = x1; x1 = x2; x2 = t;
t = y1; y1 = y2; y2 = t;
flip = 1;
end
m = (y2 - y1)/(x2 - x1);
x = (x1:x2).';
y = round(y1 + m*(x - x1));
else
if (y1 > y2)
% Always "draw" from bottom to top.
t = x1; x1 = x2; x2 = t;
t = y1; y1 = y2; y2 = t;
flip = 1;
end
m = (x2 - x1)/(y2 - y1);
y = (y1:y2).';
x = round(x1 + m*(y - y1));
end
if (flip)
x = flipud(x);
y = flipud(y);
end
end