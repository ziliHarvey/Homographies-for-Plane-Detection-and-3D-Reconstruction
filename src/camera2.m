function [M2s] = camera2(E)
% adapted from 16720 Hw4
% compute combinations of [R t] for camera 2 given essential matrix
% input:
%   E: essential matrix, (3, 3)
% output:
%   M2s: an array of Rt, [4, 3, 4]
M2s = zeros(3, 4, 4);
[U, S, V] = svd(E);
m = (S(1) + S(2)) / 2.0;
E = U * diag([m, m, 0]) * V';
[U, ~, V] = svd(E);
W = [0, -1, 0; 1, 0, 0; 0, 0, 1];
if det(U * W * V') < 0
    W = -W;
end
t = reshape(U(:, 3) / max(abs(U(:, 3))), [3, 1]);
M2s(:, :, 1) = cat(2, U*W*V', t);
M2s(:, :, 2) = cat(2, U*W*V', -t);
M2s(:, :, 3) = cat(2, U*W'*V', t);
M2s(:, :, 4) = cat(2, U*W'*V', -t);
end

