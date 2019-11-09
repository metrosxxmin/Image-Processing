function edge_image = my_canny_edge(img, low_th, high_th, filter_size)
% Find edge of Image using canny edge detection
% img         : Grayscale image    dimension ( height x width )
% low_th      : low threshold      type ( uint8 )
% high_th     : high threshold     type ( uint8 )
% filter_size : size of filter     type ( int64 )
% edge_image  : edge of input img  dimension ( height x width )
pad_size = floor(filter_size/2);
pad_img = my_padding(img, pad_size, 'mirror');
[x, y] = size(img);
filter_img = zeros(x, y);

% make Gaussian filter using meshgrid function
[X, Y] = meshgrid(-pad_size:pad_size, -pad_size:pad_size);
% default sigma
sigma = sqrt(2);
g_mask = exp(-(X.^2+Y.^2)/(2*(sigma^2)));
g_mask = g_mask / (2*pi*(sigma^2));
g_mask = g_mask / sum(sum(g_mask));

for i = 1:x
   for j = 1:y
       filter_img(i,j) = sum(sum(double(pad_img(i:i+filter_size-1,j:j+filter_size-1)).*g_mask));
   end
end

pad_size = floor(filter_size/2);
pad_img = my_padding(img, pad_size, 'mirror');
[x, y] = size(img);
filter_img = zeros(x, y);

% make Sobel filter (horizontal and vertical)
pad_img = my_padding(filter_img, pad_size, 'zero');
v_img = zeros(x, y);
h_img = zeros(x, y);
v_mask = [1:pad_size+1 pad_size:-1:1]' * [-pad_size:pad_size];
h_mask = v_mask';
for i = 1:x
    for j = 1:y
        v_img(i,j) = sum(sum(double(pad_img(i:i+filter_size-1,j:j+filter_size-1)).*v_mask)); 
        h_img(i,j) = sum(sum(double(pad_img(i:i+filter_size-1,j:j+filter_size-1)).*h_mask)); 
    end
end
magnitude = sqrt(v_img.^2 + h_img.^2);
angle_s = atan(abs(h_img)./abs(v_img)) * 180/pi;

% calculation Non-Maximum Suppression
for i = 2 : x-1
    for j = 2 : y-1
        if 0 <= angle_s(i, j) && angle_s(i, j) < 45
            tmp1 = magnitude(i-1, j+1)*tan(angle_s(i,j)) + magnitude(i, j+1)*(1-tan(angle_s(i,j)));
            tmp2 = magnitude(i+1, j-1)*tan(angle_s(i,j)) + magnitude(i, j-1)*(1-tan(angle_s(i,j)));
            if magnitude(i, j) < tmp1 || magnitude(i, j) < tmp2
                magnitude(i, j) = 0;
            end
        elseif 45 <= angle_s(i, j) && angle_s(i, j) < 90
            tmp1 = magnitude(i-1, j)*(1-cot(angle_s(i,j))) + magnitude(i-1, j+1)*cot(angle_s(i,j));
            tmp2 = magnitude(i+1, j)*(1-cot(angle_s(i,j))) + magnitude(i+1, j-1)*cot(angle_s(i,j));
            if magnitude(i, j) < tmp1 || magnitude(i, j) < tmp2
                magnitude(i, j) = 0;
            end
        elseif 90 <= angle_s(i, j) && angle_s(i, j) < 135
            tmpAngle = 180 - angle_s(i, j);
            tmp1 = magnitude(i-1, j)*(1-cot(tmpAngle)) + magnitude(i-1, j-1)*cot(tmpAngle);
            tmp2 = magnitude(i+1, j)*(1-cot(tmpAngle)) + magnitude(i+1, j+1)*cot(tmpAngle);
            if magnitude(i, j) < tmp1 || magnitude(i, j) < tmp2
                magnitude(i, j) = 0;
            end
        elseif 135 <= angle_s(i, j) && angle_s(i, j) < 180
            tmpAngle = 180 - angle_s(i, j);
            tmp1 = magnitude(i-1, j-1)*tan(tmpAngle) + magnitude(i, j-1)*(1-tan(tmpAngle));
            tmp2 = magnitude(i+1, j+1)*tan(tmpAngle) + magnitude(i, j+1)*(1-tan(tmpAngle));
            if magnitude(i, j) < tmp1 || magnitude(i, j) < tmp2
                magnitude(i, j) = 0;
            end
        end;
    end;
end;

% double thresholding ( search & add Queue)
result = zeros(x, y);
check = zeros(x, y);     % check visited element for BFS
q = zeros(2, x*y);      
index = 1;

for i = 2 : x - 1
    for j = 2 : y - 1 
        if magnitude(i, j) <= low_th
            result(i, j) = 0;
        elseif low_th < magnitude(i, j) && magnitude(i, j) < high_th
            result(i, j) = 0.5;
        elseif high_th <= magnitude(i, j)
            result(i, j) = 1;
            check(i, j) = 1;
            q(1, index) = i;    q(2, index) = j;
            index = index + 1;
        end
    end
end

% search to BFS
for i = 1 : index
    a = q(1, i);
    b = q(2, i);
    if result(a-1, b) == 0.5 && check(a-1, b) == 0
        check(a-1, b) = 1;
        q(1, index) = a-1;
        q(2, index) = b;
        result(a-1, b) = 1;
        index = index + 1; 
    end
    if result(a, b-1) == 0.5 && check(a, b-1) == 0
        check(a, b-1) = 1;
        q(1, index) = a;
        q(2, index) = b-1;
        result(a, b-1) = 1;
        index = index + 1;
    end
    if result(a, b+1) == 0.5 && check(a, b+1) == 0
        check(a, b+1) = 1;
        q(1, index) = a-1;
        q(2, index) = b+1;
        result(a, b+1) = 1;
        index = index + 1;
    end
    if result(a+1, b) == 0.5 && check(a+1, b) == 0
        check(a+1, b) = 1;
        q(1, index) = a+1;
        q(2, index) = b;
        result(a+1, b) = 1;
        index = index + 1;
    end
end
for i = 1 : x
    for j = 1 : y
        if result(i, j) == 0.5 || check(i, j) == 0
            result(i, j) = 0;
        end
    end
end

edge_image = uint8(result.*255);

end
