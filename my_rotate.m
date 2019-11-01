function re_ing = my_rotate(img, rad, interpolation)
% img	: input gray scale image
% rad	: required rotation angle (unit: radian)
% interpolation : select method (nearest, bilinear)

c = cos(rad);
s = sin(rad);
[x, y] = size(img);
f = [c s; -s c];

if strcmp(interpolation, 'nearest')

elseif strcmp(interpolation, 'bilinear')

end

re_img = uint8(re_img);
end
