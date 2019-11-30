function [H] = computeH(locs1,locs2)
% calculate H using DLT and SVD
% Input:
%   locs1, (n, 2), n should be at least 4
%   locs2, (n, 2)
% Output:
%   H, (3, 3)
num = size(locs1, 1);
A = zeros(2*num, 9);
for i = 1 : num
    x1 = locs1(i, 1); y1 = locs1(i, 2);
    x2 = locs2(i, 1); y2 = locs2(i, 2);
    A(i*2-1, :) = [-x1, -y1, -1, 0, 0, 0, x1*x2, y1*x2, x2];
    A(i*2, :)   = [0, 0, 0, -x1, -y1, -1, x1*y2, y1*y2, y2];
end
[~, ~, v] = svd(A);
% v(:, end) = [h11, h12, h13, h21, h22, h23, h31, h32, h33]'
H = v(:, end);
H = reshape(H, [3, 3]);
% important to transpose
H = H';
end

