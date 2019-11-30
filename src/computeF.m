function [F] = computeF(H,locs1, locs2)
% estimate Fundamental matrix using planar constraint. 4+2 pt algorithm
% Multiple View Geometry Textbook p336
% Input;
%   H: Homography matrix, (3, 3)
%   locs1: points on image pair 1 outside of the plane of H, (n, 2)
%   locs2: points on image pair 2 outside of the plane of H, (n, 2)
% Output:
%   F: Fundamental matrix, (3, 3)

% iter = 1000;
% % ideally p2'Fp1 = 0
% eps  = 1;
% for i = 1 : iter

num = size(locs1, 1);
idx = randsample(num, 2);
% the first pair outside plane
pt1_1 = [locs1(idx(1), 1), locs1(idx(1), 2), 1]';
pt1_warped = H * pt1_1;
pt1_warped = pt1_warped / pt1_warped(3);
pt1_2 = [locs2(idx(1), 1), locs2(idx(1), 2), 1]';
l1 = cross(pt1_warped, pt1_2);
% the second pair outside plane
pt2_1 = [locs1(idx(2), 1), locs1(idx(2), 2), 1]';
pt2_warped = H * pt2_1;
pt2_warped = pt2_warped / pt2_warped(3);
pt2_2 = [locs2(idx(2), 1), locs2(idx(2), 2), 1]';
l2 = cross(pt2_warped, pt2_2);
% determine epipole e'
e2 = cross(l1, l2);
e2 = e2 / e2(3);
disp('e2...................');
disp(e2);
e2_skew = [0, -e2(3), e2(2); e2(3), 0, -e2(1); -e2(2), e2(1), 0];
F = e2_skew * H;
F = F / F(3, 3);
end

