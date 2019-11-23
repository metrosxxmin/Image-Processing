function erosion = my_erosion(img, filter)
% Apply erosion of binary image
% img     : binary image
% filter  : filter for erosion
% erosion : result of erosion

[row, col] = size(img);
[filter_x,filter_y] = size(filter);
pad_x = floor(filter_x/2);
pad_y = floor(filter_y/2);
erosion = zeros(row, col);

% Apply erosion
for i = 1 + pad_x : row - pad_x
    for j = 1 + pad_y : col - pad_y
        if filter == filter & img(i-pad_x:i+pad_x,j-pad_y:j+pad_y)
            erosion(i, j) = 1;
        end
    end
end
