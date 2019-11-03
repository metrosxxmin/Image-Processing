function [thres_img, level] = my_threshold(img, type)
% Find Threshold 
% img       : GrayScale Image     dimension (height x width)
% type      : kinds of threshold  {'within', 'between'}
% thres_img : threshold image     dimension (height x width)
% level     : threshold value     type( uint8 )
thres_img = img;

img_PDF = zeros(1, 256);
[x, y] = size(img);

for i = 1:x
    for j = 1:y
        img_PDF(img(i, j)+1) = img_PDF(img(i, j)+1) + 1;
    end
end

if strcmp(type, 'within')

elseif strcmp(type, 'between')

end
thres_img = uint8(img);

end

