clear all
close all
f = imread('circular_stroke.tif');
%% a)
h = ones(9,9)/81;
g = imfilter(f,h);

%% b)
[gB,~] = Otsu_Thresholding(g);

%% c)
B = bwboundaries(gB);
B1 = B{1}; % Main boundary is chosen
M = size(f,1);
N = size(f,2);
image = bound2im(B1,M,N);
figure()
imshow(image)

%% d)
gridsep=50;
[s, sUnit] = bsubsamp(B1, gridsep);
image2 = bound2im(s,M,N);
figure()
imshow(image2)


b = connectpoly(s(:,1), s(:,2));
image3 = bound2im(b,M,N);
figure()
imshow(image3)
%[x, y] = intline(x1, x2, y1, y2);

%% e)

c = FreemanChainCode(b);

%% functions
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

function [s, sUnit] = bsubsamp(b, gridsep)
%BSUBSAMP Subsample a boundary.
% [S, SUNIT] = BSUBSAMP(B, GRIDSEP) subsamples the boundary B by
% assigning each of its points to the grid node to which it is
% closest. The grid is specified by GRIDSEP, which is the
% separation in pixels between the grid lines. For example, if
% GRIDSEP = 2, there are two pixels in between grid lines. So, for
% instance, the grid points in the first row would be at (1,1),
% (1,4), (1,6), ..., and similarly in the y direction. The value
% of GRIDSEP must be an even integer. The boundary is specified by
% a set of coordinates in the form of an np-by-2 array. It is
% assumed that the boundary is one pixel thick.
%
% Output S is the subsampled boundary. Output SUNIT is normalized so
% that the grid separation is unity. This is useful for obtaining
% the Freeman chain code of the subsampled boundary. The outputs are
% in the same order (clockwise or counterclockwise) as the input.
% There are no duplicate points in the output.
% Check input.
[np, nc] = size(b);
if np < nc
error('B must be of size np-by-2.');
end
if isinteger(gridsep)
error('GRIDSEP must be an integer.')
end
% Findthe maximum span of the boundary.
xmax = max(b(:, 1));
ymax = max(b(:, 2));
% Determine the integral number of grid lines with gridsep points in
% between them that encompass the intervals [1,xmax], [1,ymax].
GLx = ceil((xmax + gridsep)/(gridsep + 1));
GLy = ceil((ymax + gridsep)/(gridsep + 1));
% Form vectors of x and y grid locations.
I = 1:GLx;
J = 1:GLy;
% Vector of grid line locations intersecting x-axis.
X(I) = gridsep*I + (I - gridsep);
% Vector of grid line locations intersecting y-axis.
Y(J) = gridsep*J + (J - gridsep);
[C, R] = meshgrid(Y, X);
% Vector of grid all coordinates, arranged as Numbergridpoints-by-2
% array to match the horizontal dimensions of b. This allows
% computation of distances to be vectorized and this be much more
% efficient.
V = [C(1:end) ; R(1:end)]';
% Compute the distance between every element of b and every element
% of the grid.
p = np;
q = size(V, 1);
D = sqrt(sum(abs(repmat(permute(b, [1 3 2]), [1 q 1])...
- repmat(permute(V, [3 1 2]), [p 1 1])).^2, 3));
% D(i, j) is the distance between the ith row of b and the jth
% row of V. Find the min between each element of b and V.
new_b = zeros(np, 2); % Preallocate memory.
for I = 1:np
idx = find(D(I,:) == min(D(I,:)), 1); % One min in row I of D.
new_b(I,:) = V(idx, :);
end
% Eliminate duplicates and keep same order as input
[s, m] = unique(new_b, 'rows');
s = [s, m];
s = fliplr(s);
s = sortrows(s);
s = fliplr(s);
s = s(:, 1:2);
% Scale to unit grid so that can use directly to obtain Freeman
% chain codes. The shape does not change.
sUnit = round(s./gridsep) + 1;
end

function c = connectpoly(x, y)
% CONNECTPOLY Connects vertices of a polygon.
% C = CONNECTPOLY(X, Y) connects the points with coordinates given
% in X and Y with straight lines. These points are assumed to be a
% sequence of polygon vertices organized in the clockwise or
% counterclockwise direction. The output, C, is the set of points
% along the boundary of the polygon in the form of an nr-by-2
% coordinate sequence in the same direction as the input. The last
% point in the sequence is equal to the first.
v = [x(:), y(:)];
% Close the polygon.
if ~isequal(v(end,:), v(1,:))
v(end + 1, :) = v(1, :);
end
% Connect vertices.
segments = cell(1, length(v) - 1);
for I = 2:length(v)
[x, y] = intline(v(I - 1, 1), v(I, 1), v(I - 1, 2), v(I, 2));
segments{I - 1} = [x, y];
end
c = cat(1, segments{:});
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