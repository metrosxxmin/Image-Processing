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

q1 = 0;
mG = dot( (0:255), img_PDF ); 
total = sum(img_PDF);
meanOf1 = 0;
min = inf;  max = 0.0;
V1 = 0.0; V2 = 0.0;
between = 0; within = 0;

if strcmp(type, 'within')
    for i = 0 : 255
        q1 = q1 + img_PDF(i + 1);
        q2 = total - q1;
        if (q1 == 0 || q2 == 0)
            continue;
        end
        meanOf1 = meanOf1 + (i + 1)*img_PDF(i + 1);
        meanOf2 = mG - meanOf1;
        m1 = meanOf1/q1;
        m2 = meanOf2/q2;
        V1 = V1 + ((i + 1)*meanOf1)/q1 - m1^2;
        V2 = V2 + ((i + 1)*meanOf2)/q2 - m2^2;       
        within = q1*V1 + q2*V2;
        if (within < min)
            level = i + 1;
            min = within;
        end
    end

elseif strcmp(type, 'between')

end
thres_img = uint8(img);

end

