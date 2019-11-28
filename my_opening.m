function opening = my_opening(img, filter)
% Apply opening of binary image
% img     : binary image
% filter  : filter for opening
% opening : result of opening

[row, col] = size(img);
[filter_x, filter_y] = size(filter);
pad_x = floor(filter_x/2);
pad_y = floor(filter_y/2);
erosion = zeros(row, col);

% Apply opening
for i = 1 + pad_x : row - pad_x
    for j = 1 + pad_y : col - pad_y
        if filter == filter & img(i-pad_x:i+pad_x,j-pad_y:j+pad_y)
            erosion(i, j) = 1;
        end
    end
end

pad_img = zeros(row+2*pad_x, col+2*pad_y);
pad_img(1 + pad_x : row + pad_x, 1 + pad_y : col+pad_y) = erosion;
bias_img = pad_img;

for i = -pad_x : pad_x
    for j = -pad_y : pad_y
        if filter(i + pad_x+1, j + pad_y+1) == 1
            pad_img(1+pad_x + i : row+pad_x + i, 1+pad_y + j: col+pad_y + j) = img;
            bias_img = bias_img | pad_img;
        end
    end
end

opening = bias_img(1 + pad_x : row + pad_x, 1 + pad_y : col+pad_y);
end
