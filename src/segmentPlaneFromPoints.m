function [plane_mask] = segmentPlaneFromPoints(img_rgb,pts1, pts2)
% Selected a plane region from classified feature points using convhull and inpolygon
% Input:
%   img_rgb: rgb image, (m, n)
%   pts1: feature points on plane 1, (n1, 2)
%   pts2: feature points on plane 2, (n1, 2)
% output:
%   plane1: regions of pixels of plane1, (n2, 2), n2 >> n1
%   plane2: regions of pixels of plane2, (n2, 2)

[m, n, ~] = size(img_rgb);
plane_mask = zeros(m, n);
% segment plane 1
boundary_idx1 = convhull(pts1);
% figure;
% hold off;
% imshow(img_rgb);
% hold on;
% plot(pts1(boundary_idx1, 1), pts1(boundary_idx1, 2), 'LineWidth', 5);
% hold on;
plane1 = poly2mask(pts1(boundary_idx1, 1), pts1(boundary_idx1, 2), m, n);

% segment plane 2
boundary_idx2 = convhull(pts2);
plane2 = poly2mask(pts2(boundary_idx2, 1), pts2(boundary_idx2, 2), m, n);

% visualization
for i = 1 : m
    for j = 1 : n
        if plane1(i, j) ~= 0
            img_rgb(i, j, 2) = 0;
            plane_mask(i, j) = 1;
        elseif plane2(i, j) ~= 0
            img_rgb(i, j, 3) = 0;
            plane_mask(i, j) = 2;
        end
    end
end
imshow(img_rgb);
end

