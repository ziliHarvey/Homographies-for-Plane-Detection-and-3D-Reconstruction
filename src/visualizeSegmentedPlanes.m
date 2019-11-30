function [plane_mask] = visualizeSegmentedPlanes(img,pts1, pts2, pair_name)
% visualize segmented plane
figure(1);
hold off;
imshow(img);
hold on;
for i = 1 : size(pts1, 1)
    plot(pts1(i, 1), pts1(i, 2), 'ro', 'MarkerSize', 5, 'Color', 'r');
    hold on;
end
for i = 1 : size(pts2, 1)
    plot(pts2(i, 1), pts2(i, 2), '*', 'MarkerSize', 5, 'Color', 'g');
    hold on;
end
fig = getframe;
imwrite(fig.cdata, strcat('../results/points_segmented_', pair_name)); 
plane_mask = segmentPlaneFromPoints(img, pts1, pts2);
fig = getframe;
imwrite(fig.cdata, strcat('../results/plane_segmented_', pair_name)); 
hold off;
end

