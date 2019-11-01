function re_ing = my_rotate(img, rad, interpolation)
% img	: input gray scale image
% rad	: required rotation angle (unit: radian)
% interpolation : select method (nearest, bilinear)

c = cos(rad);
s = sin(rad);
[x, y] = size(img);

% for rotating image, 2 by 2 matrix.
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
	img = padding(img);
    for i = 1 : row
       for j = 1 : col
           v = f * (double([i; j]) - double([row/2; col/2]));
           v = v + double([x/2; y/2]);
           if v(1) < 1 || v(1) > x || v(2) < 1 || v(2) > y
              continue; 
           end                     
            
            m = ceil(v(1));
            n = ceil(v(2));
            t = abs(v(1) - m);
            s = abs(v(2) - n);
            sq1 = (1-s)*(1-t)*img(m, n);
            sq2 = (s*(1-t)*img(m,n+1));
            sq3 = ((1-s)*t*img(m+1,n));
            sq4 = (s*t*img(m+1,n+1));
            re_img(i, j) = sq1 + sq2 + sq3 + sq4;
                       
       end
    end
end

re_img = uint8(re_img);
end
