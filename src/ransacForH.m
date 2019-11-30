function [H_best,locs1_inliers, locs1_outliers, locs2_inliers, locs2_outliers] = ransacForH(locs1,locs2)
% estimating H using ransac
% Input:
%   locs1: interesting points in image pair 1, (n, 2)
%   locs2: interesting points in image pair 2, (n, 2)
% Output:
%   H: best homography from image1 to image2
%   locs1_inliers: inlier points in locs1, (n1, 2)
%   locs1_outliers: outliers points in locs2, (n-n1, 2)
%   locs2_inliers: inlier points in locs1, (n1, 2)
%   locs2_outliers: outliers points in locs2, (n-n1, 2)
eps = 3;
iter = 20000;
num = size(locs1, 1);
num_max = 0;
inliers_best = zeros(num);
for i = 1:iter
    num_cur = 0;
    inliers_cur = zeros(num);
    % need 4 pairs to compute a candidate homography
    idx = randsample(num, 4);
    locs1_cur = cat(1, locs1(idx(1), :), locs1(idx(2), :), locs1(idx(3), :), locs1(idx(4), :));
    locs2_cur = cat(1, locs2(idx(1), :), locs2(idx(2), :), locs2(idx(3), :), locs2(idx(4), :));
    H_cur = computeH(locs1_cur, locs2_cur);
%     H_cur = H_cur / H_cur(3, 3);
    % count number of inliers
    for j = 1 : num
        pt1 = [locs1(j, 1), locs1(j, 2), 1]';
        pt2 = [locs2(j, 1), locs2(j, 2), 1]';
        pt1_warped = H_cur * pt1;
        pt1_warped = pt1_warped / pt1_warped(3);
%         disp(pt1_warped)
        dist = norm(pt1_warped-pt2);
%         disp(dist);
        if dist < eps
            num_cur = num_cur + 1;
            inliers_cur(j) = 1;
        end
    end
    % check and update
    if num_cur > num_max
        num_max = num_cur;
        inliers_best = inliers_cur;
    end
end
disp('......................');
disp('Number of inliers');
disp(num_max);
disp('Number of total');
disp(num);
% compute best H using all inliers
locs1_inliers = zeros(num_max, 2);
locs2_inliers = zeros(num_max, 2);
locs1_outliers = zeros(num - num_max, 2);
locs2_outliers = zeros(num - num_max, 2);
idx_in = 1; idx_out = 1;
for k = 1 : num
    if inliers_best(k) ~= 0
        locs1_inliers(idx_in, :) = locs1(k, :);
        locs2_inliers(idx_in, :) = locs2(k, :);
        idx_in = idx_in + 1;
    else
        locs1_outliers(idx_out, :) = locs1(k, :);
        locs2_outliers(idx_out, :) = locs2(k, :);
        idx_out = idx_out + 1;
    end
end
H_best = computeH(locs1_inliers, locs2_inliers);
end

