function closing = my_closing(img, filter)
% Calculate closing of binary image
% img     : binary image
% filter  : filter for closing
% closing : result of closing

[row, col] = size(img);
[filter_x, filter_y] = size(filter);
pad_x = floor(filter_x/2);
pad_y = floor(filter_y/2);
pad_img = zeros(row+2*pad_x, col+2*pad_y);
pad_img(1 + pad_x : row + pad_x, 1 + pad_y : col+pad_y) = img;
bias_img = pad_img;

% Apply closing
for i = -pad_x : pad_x
    for j = -pad_y : pad_y
        if filter(i + pad_x+1, j + pad_y+1) == 1
            pad_img(1+pad_x + i : row+pad_x + i, 1+pad_y + j: col+pad_y + j) = img;
            bias_img = bias_img | pad_img;
        end
    end
end

dilation = bias_img(1 + pad_x : row + pad_x, 1 + pad_y : col+pad_y);
closing = zeros(row, col);

for i = 1 + pad_x : row - pad_x
    for j = 1 + pad_y : col - pad_y
        if filter == filter & dilation(i-pad_x:i+pad_x,j-pad_y:j+pad_y)
            closing(i, j) = 1;
        end
    end
end

end
