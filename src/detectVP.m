function [vps] = detectVP(img_rgb)
img_gray = rgb2gray(img_rgb);
[m, n] = size(img_gray);
addpath('lineCodes/derekhoiem');
%__________________________________________________________________________
% detect lines
lines = APPgetLargeConnectedEdges(img_gray,0.025*sqrt(m*m + n*n));
[num_lines, ~] = size(lines);
thetas = lines(:, 5);
idx = kmeans(thetas, 3);
color = ['r', 'g', 'b'];
figure(1);
hold off;
imshow(img_rgb);
hold on;
% cluster is cell array, each cell contains the ids of line segment corresponding
% to the same cluster
% clusters = {[], [], [], [], [], []};
clusters = {[], [], []};
for i = 1 : num_lines
    cluster_id = idx(i);
    clusters{cluster_id} = [clusters{cluster_id}, i];
    line(lines(i, [1 2])', lines(i, [3 4])', 'color', color(cluster_id));
end

vps = zeros(3, 3);
for i = 1 : size(clusters, 2)
    [vp, num_inliers] = ransacForVP(lines, clusters, i);
    vps(i, 1:2) = vp(1:2);
    vps(i, 3) = i;
end
end

