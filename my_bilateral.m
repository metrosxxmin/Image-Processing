function filter_img = my_bilateral(img, filter_size, sigma_s, sigma_r)
[row, col] = size(img);
fileter_img = zeros(row, col);
pad_size = floor(filter_size/2);
pad_img = double(my_padding(img, pad_size, 'mirror'));

[X, Y] = meshgrid(-pad_size:pad_size, -pad_size:pad_size);
Gmask = exp(-(X.^2+Y.^2)/(2*sigma_s^2));

for i = 1 : row
    for j = 1 : col
        
        x1 = max(i-pad_size, 1);
        x2 = min(i+pad_size, row);
        y1 = max(j-pad_size, 1);
        y2 = min(j+pad_size, col);
        
        I_block = pad_img(x1:x2, y1:y2);
        f_block = (exp(-(I_block-pad_img(i,j)).^2/(2*sigma_r^2))).*Gmask((x1:x2)-i+pad_size+1,(y1:y2)-j+pad_size+1);
        fileter_img(i, j) = sum(f_block(:).*I_block(:))/sum(f_block(:));
   end
end

filter_img = uint8(fileter_img);
