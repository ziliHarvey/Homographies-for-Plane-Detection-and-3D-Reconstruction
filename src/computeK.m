function [K] = computeK(img_rgb, debug)
% compute intrinsic matrix from 3 orthogonal vanishing points
% assuming zero skew and square pixel
if debug == 1
    vps = [575.7863, -5825.1, 1;
              2148, 599.5702, 1;
         -493.9273, 579.1494, 1];
elseif debug == 2
    vps = [441.7469, -4147.5, 1;
            -30.1740, 608.1293, 1;
            3498.1, 612.2188, 1];
else
    vps = detectVP(img_rgb);
end


% Let w = (KK^T)^-1
% w = [w1,  0, w2;
%       0, w1, w3;
%      w2, w3, w4]
% from textbook P226
% can be written as AW = 0
% A is (3, 4)
A = [vps(1, 1)*vps(2,1)+vps(1,2)*vps(2,2), vps(1,1)+vps(2,1), vps(1,2)+vps(2,2), 1;
     vps(2, 1)*vps(3,1)+vps(2,2)*vps(3,2), vps(2,1)+vps(3,1), vps(2,2)+vps(3,2), 1;
     vps(3, 1)*vps(1,1)+vps(3,2)*vps(1,2), vps(3,1)+vps(1,1), vps(3,2)+vps(1,2), 1];
[~, ~, v] = svd(A);
w = v(:, end);
W = [w(1), 0, w(2); 0, w(1), w(3); w(2), w(3), w(4)];
K = inv(chol(W));
K = K / K(3, 3);
end

