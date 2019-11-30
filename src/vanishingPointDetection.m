clear;
clc;
% _________________________________________________________________________
% load data
img_path = '../images/input/';
img_filename = '1_002.jpg';
img_rgb = imread(strcat(img_path, img_filename));
img_gray = rgb2gray(img_rgb);
[m, n] = size(img_gray);
addpath('lineCodes/derekhoiem');
%__________________________________________________________________________
% detect lines
lines = APPgetLargeConnectedEdges(img_gray,0.025*sqrt(m*m + n*n));
[num_lines, ~] = size(lines);
thetas = lines(:, 5);
%__________________________________________________________________________
% clustering using kmeans and visualize line segments by different clusters
idx = kmeans(thetas, 3);
color = ['r', 'g', 'b'];
figure(1);
hold off;
imshow(img_rgb);
hold on;
clusters = {[], [], []};
for i = 1 : num_lines
    cluster_id = idx(i);
    clusters{cluster_id} = [clusters{cluster_id}, i];
    line(lines(i, [1 2])', lines(i, [3 4])', 'color', color(cluster_id));
end
% save line segments visualization
if ~exist('../results/', 'dir')
    mkdir('../results')
end
fig = getframe;
imwrite(fig.cdata, strcat('../results/line_segments_', img_filename)); 
%__________________________________________________________________________
% estimate vanishing point using RANSAC for each cluster
vps = zeros(3, 3);
for i = 1 : size(clusters, 2)
    [vp, num_inliers] = ransacForVP(lines, clusters, i);
    vps(i, 1:2) = vp(1:2);
    vps(i, 3) = i;
end
% plot vanishing point 1
figure(2);
hold on;
cluster_id = vps(1, 3);
scatter(vps(1, 1), vps(1, 2), 30, 'MarkerFaceColor', color(cluster_id), 'MarkerEdgeColor', [0, 0, 0]);
hold on;
imshow(img_rgb);
alpha(0.4);
for i = 1 : num_lines
    cluster_id = idx(i);
    line(lines(i, [1 2])', lines(i, [3 4])', 'color', color(cluster_id));
end
hold off;

% plot vanishing point 2
figure(3);
hold on;
cluster_id = vps(2, 3);
scatter(vps(2, 1), vps(2, 2), 30, 'MarkerFaceColor', color(cluster_id), 'MarkerEdgeColor', [0, 0, 0]);
hold on;
imshow(img_rgb);
alpha(0.4);
for i = 1 : num_lines
    cluster_id = idx(i);
    line(lines(i, [1 2])', lines(i, [3 4])', 'color', color(cluster_id));
end
hold off;

% plot vanishing point 3
figure(4);
hold on;
cluster_id = vps(3, 3);
scatter(vps(3, 1), vps(3, 2), 30, 'MarkerFaceColor', color(cluster_id), 'MarkerEdgeColor', [0, 0, 0]);
hold on;
imshow(img_rgb);
alpha(0.4);
for i = 1 : num_lines
    cluster_id = idx(i);
    line(lines(i, [1 2])', lines(i, [3 4])', 'color', color(cluster_id));
end
hold off;

% plot all vanishing points
figure(5);
hold on;
for i = 1 : 3
    cluster_id = vps(i, 3);
    scatter(vps(i, 1), vps(i, 2), 30, 'MarkerFaceColor', color(cluster_id), 'MarkerEdgeColor', [0, 0, 0]);
    hold on;
end
imshow(img_rgb);
alpha(0.4);
for i = 1 : num_lines
    cluster_id = idx(i);
    line(lines(i, [1 2])', lines(i, [3 4])', 'color', color(cluster_id));
end
hold off;
