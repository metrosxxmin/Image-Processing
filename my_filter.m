function filter_img = my_filter(img, filter_size, type)
% img 		: Image, dimension (X x Y)
% filter_size	: Filter mask(kernel)'s size, type: (uint8)
% type		: Filter type. {'avr', 'weight', 'laplacion', 'median', 'sobel', 'unsharp'}
pad_size = floor(filter_size / 2);
pad_img = my_padding(img, pad_size, 'mirror');
[x, y] = size(img);
filter_img = zeros(x, y);

% applying average filter 
if strcmp(type, 'avr')

% applying weighted average filter
elseif strcmp(type, 'weight')

% applying laplacian filter
elseif strcmp(type, 'laplacian')

% applying median filter
elseif strcmp(type, 'median')

% applying sobel filter
elseif strcmp(type, 'sobel')

% applying unsharped filter
elseif strcmp(type, 'unsharp')
