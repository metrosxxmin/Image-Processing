function re_img = my_bilinear(img, row, col)
% img	: input image
% row	: input image's row
% col	: input image's column
re_img = zeros(row,col);
[x,y] = size(img);

img = padding(img);
r_p = x/row;
c_p = y/col;

for i = 1:row
    for j = 1:col
        m = ceil(r_p * i);  
        n = ceil(c_p * j);
        
        s = abs(c_p * j - n);
        t = abs(r_p * i - m);
        
        sq1 = (1 - s) * (1 - t) * img(m, n);
        sq2 = s * (1 - t) * img(m, n + 1);
        sq3 = (1 - s) * t * img(m + 1, n);
        sq4 = s * t * img(m + 1, n + 1);
        re_img(i, j) = sq1 + sq2 + sq3 + sq4;
    end
end

re_img = uint8(re_img);
