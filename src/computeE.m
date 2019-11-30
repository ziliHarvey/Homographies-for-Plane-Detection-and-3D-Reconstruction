function [E] = computeE(K1, K2, F)
% Recover Essential Matrix from Ks and F
% Input:
%   K1: intrinsic matrix of the first camera, (3, 3)
%   K2: intrinsic matrix of the second camera, (3, 3)
%   F: fundamental matrix, (3, 3)
% Output:
%   E: essential matrix, (3, 3)
E = K2' * F * K1;
E = E / E(3, 3);
end

