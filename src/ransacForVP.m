function [vp,lines_inlier_best, lines_outlier_best] = ransacForVP(lines,clusters, cluster_id)
% this function estimates vanishing point for cluster_id's correspongding
% line segments using RANSAC
% Input: 
%   lines: (nlines, [x1 x2 y1 y2 theta r])
%   clusters: (1, 6) cell array
%   cluster_id: 1~6
%   flag: true or false
% Output:
%   vp: (2, 1) x and y of the vanishing point
%   max_inliers: int, max number of inliers

% ransac settings
eps = 0.1;
iter_num = 30000;
min_num = 10;
% initial return values
line_ids = clusters{cluster_id};
num = size(line_ids, 2);
max_inliers = 0;
vp = zeros(3, 1);
lines_inlier_best = [];
lines_outlier_best = [];
% there must be enough lines in the cluster
if num < min_num
    return;
end
for i = 1 : iter_num
    lines_inlier_cur = [];
    lines_outlier_cur = [];
    cur_inliers = 0;
    % for every iteration randomly sampling 2 line segments
    samples = randsample(num, 2);
    id1 = line_ids(samples(1)); id2 = line_ids(samples(2));
    % line segment 1
    pt1_1 = [lines(id1, 1), lines(id1, 3), 1];
    pt1_2 = [lines(id1, 2), lines(id1, 4), 1];
    line1 = cross(pt1_1, pt1_2);
    % line segment 2
    pt2_1 = [lines(id2, 1), lines(id2, 3), 1];
    pt2_2 = [lines(id2, 2), lines(id2, 4), 1];
    line2 = cross(pt2_1, pt2_2);
    % calculate current vanishing point
    vp_can = cross(line1, line2);
    % normalize points
    vp_can = vp_can / vp_can(3);
    % check all line segments and count inliers/outliers
    for k = 1 : num
        line_id_cur = line_ids(k);
        v1 = [lines(line_id_cur, 1), lines(line_id_cur, 3), 1];
        v2 = [lines(line_id_cur, 2), lines(line_id_cur, 4), 1];
        line = cross(v1, v2);
        line = line / line(3);
%         dist = distPoint2Line(vp_can, v1, v2);
        error = abs(line*vp_can');
        if error <= eps
            cur_inliers = cur_inliers + 1;
            lines_inlier_cur = [lines_inlier_cur; lines(k, :)];
        else
            lines_outlier_cur = [lines_outlier_cur; lines(k, :)];
        end
    end
    % update best fit
    if cur_inliers > max_inliers
        max_inliers = cur_inliers;
        vp = vp_can;
        lines_inlier_best = lines_inlier_cur;
        lines_outlier_best = lines_outlier_cur;
    end
end
end

