function re_ing = my_rotate(img, rad, interpolation)
% img	: input gray scale image
% rad	: required rotation angle (unit: radian)
% interpolation : select method (nearest, bilinear)

c = cos(rad);
s = sin(rad);
[x, y] = size(img);
f = [c s; -s c];

row = (abs(c*x) + abs(s*y)); row_p = x / row;
col = (abs(c*y) + abs(s*x)); col_p = y / col;
re_img = zeros(row, col);

if strcmp(interpolation, 'nearest')
    for i = 1 : row
       for j = 1 : col
           v = f * (double([i; j]) - double([row/2; col/2]));
           v = v + double([x/2; y/2]);
           if v(1) < 1 || v(1) > x || v(2) < 1 || v(2) > y
              continue; 
           end           
           re_img(i, j) = img(round(v(1)), round(v(2)));
       end
    end

elseif strcmp(interpolation, 'bilinear')

end

re_img = uint8(re_img);
end
