clear;
clc;
% __________________________________________
% load data pair
img_path = '../images/input/';
if ~exist('../results/', 'dir')
    mkdir('../results/')
end
% pair1.....................................
file_name1 = '1_002.jpg';
file_name2 = '1_003.jpg';

% % pair2...................................
% file_name1 = 'b1.jpg';
% file_name2 = 'b2.jpg';

% % % pair3.................................
% % file_name1 = 'a4.jpg';
% % file_name2 = 'a5.jpg';

% % pair4...................................
% file_name1 = 'a3.jpg';
% file_name2 = 'a6.jpg';

img1_rgb = imread(strcat(img_path, file_name1));
img2_rgb = imread(strcat(img_path, file_name2));
img1_gray = rgb2gray(img1_rgb);
img2_gray = rgb2gray(img2_rgb);
%___________________________________________
% detect feature and match correspondence
% reference: 
% https://www.mathworks.com/help/vision/ref/matchfeatures.html#d117e169639
% Using SURF 
points1 = detectSURFFeatures(img1_gray, 'MetricThreshold', 700);
points2 = detectSURFFeatures(img2_gray, 'MetricThreshold', 700);

[features1,valid_points1] = extractFeatures(img1_gray,points1);
[features2,valid_points2] = extractFeatures(img2_gray,points2);
indexPairs = matchFeatures(features1,features2);
matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);
figure; showMatchedFeatures(img1_gray,img2_gray,matchedPoints1,matchedPoints2);
hold on;
fig = getframe;
imwrite(fig.cdata, strcat('../results/correspondence_', file_name1(1:end-4), '_', file_name2(1:end-4), '.jpg')); 

% assuming segmenting 2 planes
% estimating plane1
[H1, locs1_in_plane1, locs1_out_plane1, locs2_in_plane1, locs2_out_plane1] = ransacForH(matchedPoints1.Location, matchedPoints2.Location);
% estimating plane2
[H2, locs1_in_plane2, locs1_out_plane2, locs2_in_plane2, locs2_out_plane2] = ransacForH(locs1_out_plane1, locs2_out_plane1);
pts1_inliers = cat(1, locs1_in_plane1, locs1_in_plane2);
pts2_inliers = cat(1, locs2_in_plane1, locs2_in_plane2);
plane_mask = visualizeSegmentedPlanes(img1_rgb, locs1_in_plane1, locs1_in_plane2, strcat(file_name1(1:end-4), '_', file_name2(1:end-4), '.jpg'));

% One plane homography H1 and 2 sets of points not on that plane is
% selected to estimate F
F = computeF(H1, locs1_in_plane2, locs2_in_plane2);
% calculate K
K1 = computeK(img1_rgb, 0);
K2 = computeK(img2_rgb, 0);


% calculate E
E = computeE(K1, K2, F);
% calculate R and t
M2s = camera2(E);
% triangulation and select the correct case
C1 = cat(2, eye(3), zeros(3, 1));
M1 = K1*C1;
M2 = zeros(3, 4);
max_depth = 0;
P1_best = 0;
P2_best = 0;
for i = 1 : 4
    [P1, err1] = triangulate(M1, locs1_in_plane1, K2*M2s(:, :, i), locs2_in_plane1);
    [P2, err2] = triangulate(M1, locs1_in_plane2, K2*M2s(:, :, i), locs2_in_plane2);
    % depth shouldn't be negative
    min_col1 = min(P1, [], 1);
    min_depth1 = min_col1(3);
    min_col2 = min(P2, [], 1);
    min_depth2 = min_col2(3);
    min_depth = min(min_depth1, min_depth2);
    if min_depth > max_depth
        max_depth = min_depth;
        P1_best = P1;
        P2_best = P2;
    end
end
P1 = P1_best;
P2 = P2_best;
% ------------------------------------------
% plot with assigned pixel intensity
num_pt1 = size(locs1_in_plane1, 1);
color1 = zeros(num_pt1, 3);
img1_double = im2double(img1_rgb);
for i = 1 : num_pt1
    r = ceil(locs1_in_plane1(i, 2));
    c = ceil(locs1_in_plane1(i, 1));
    color1(i, :) = img1_double(r, c, :);
end

num_pt2 = size(locs1_in_plane2, 1);
color2 = zeros(num_pt2, 3);
for i = 1 : num_pt2
    r = ceil(locs1_in_plane2(i, 2));
    c = ceil(locs1_in_plane2(i, 1));
    color2(i, :) = img1_double(r, c, :);
end

% plot 3d points with pixel color
figure;
axis on;
scatter3(P1(:, 1), P1(:, 2), P1(:, 3), 10, color1, 'filled');
hold on;
scatter3(P2(:, 1), P2(:, 2), P2(:, 3), 10, color2, 'filled');
xlabel('X');
ylabel('Y');
zlabel('Z');
hold off;

% plot 3d points segmented by 2 planes
figure;
axis on;
scatter3(P1(:, 1), P1(:, 2), P1(:, 3), 'MarkerFaceColor', [1, 0, 0]);
hold on;
scatter3(P2(:, 1), P2(:, 2), P2(:, 3), 'MarkerFaceColor', [0, 0, 1]);
xlabel('X');
ylabel('Y');
zlabel('Z');
hold off;


