function [P,err] = triangulate(M1,pts1, M2, pts2)
% adapted from 16720 hw4
num = size(pts1, 1);
P = zeros(num, 3);
A = zeros(4, 4);
for i = 1 : num
    x_1 = pts1(i, 1);
    x_2 = pts2(i, 1);
    y_1 = pts1(i, 2);
    y_2 = pts2(i, 2);
    p1_1 = M1(1, :);
    p2_1 = M1(2, :);
    p3_1 = M1(3, :);
    p1_2 = M2(1, :);
    p2_2 = M2(2, :);
    p3_2 = M2(3, :);
    A(1, :) = y_1 * p3_1 - p2_1;
    A(2, :) = p1_1 - x_1 * p3_1;
    A(3, :) = y_2 * p3_2 - p2_2;
    A(4, :) = p1_2 - x_2 * p3_2;
    [~, ~, v] = svd(A);
    P_tmp = v(:, end);
    P_tmp = reshape(P_tmp, [4, 1]);
    P_tmp = P_tmp / P_tmp(4, 1);
    P(i, :) = [P_tmp(1, 1), P_tmp(2, 1), P_tmp(3, 1)];
end
% calculate error
P_T = P';
P_T = cat(1, P_T, ones(1, num));
p_1 = M1 * P_T;
p_2 = M2 * P_T;
for i = 1 : num
    p_1(:, i) = p_1(:, i) / p_1(3, i);
    p_2(:, i) = p_2(:, i) / p_2(3, i);
end
p_predict1 = p_1(1:2, :)';
p_predict2 = p_2(1:2, :)';
err = sum((p_predict1 - pts1).^2, 'all') + sum((p_predict2 - pts2).^2, 'all');
end

