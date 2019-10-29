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
	for i = 1 : x
		for j = 1 : y
			mean_1D = mean(pad_img(i : i+filter_size-1, j : j+filter_size-1));
			filter_img(i, j) = mean(mean_1D);
		end
	end

% applying weighted average filter
elseif strcmp(type, 'weight')
	mask = [1:pad_size+1 pad_size:-1:1]' * [1:pad_size+1 pad_size:-1:1];
    s = sum(sum(mask));
    for i = 1 : x
        for j = 1 : y
            sum_1D = sum(double(pad_img(i : i+filter_size-1,j : j+filter_size-1)).*mask);
            filter_img(i, j) = sum(sum_1D)/s;
		end
    end
	
% applying laplacian filter
elseif strcmp(type, 'laplacian')

% applying median filter
elseif strcmp(type, 'median')
	for i = 1 : x
        for j = 1 : y
			median_1D = median(double(pad_img(i : i+filter_size-1,j : j+filter_size-1)));
            filter_img(i, j) = median(median_1D); 
        end
    end

% applying sobel filter
elseif strcmp(type, 'sobel')
	v_img = zeros(x, y);
	h_img = zeros(x, y);

	v_mask = [1 : pad_size+1 pad_size : -1 : 1]' * [-pad_size : pad_size];
    h_mask = v_mask';
    for i = 1 : x
        for j = 1 : y
			temp = double(pad_img(i:i+filter_size-1,j:j+filter_size-1));
        	v_img(i, j) = sum(sum(temp.*v_mask)); 
        	h_img(i, j) = sum(sum(temp.*h_mask)); 
        	filter_img(i, j) = v_img(i, j) + h_img(i, j);
        end
    end
% applying unsharped filter
elseif strcmp(type, 'unsharp')
	k = 0.5;
	mask = zeros(filter_size);
	mask(ceil(filter_size / 2), ceil(filter_size / 2)) = 1;
	A = 1/9 * ones(filter_size);
	mask = (1 / (1-k)) * mask - (k / (1-k)) * A;
	for i = 1 : x
		for j = 1 : y
			sum_1D = sum(double(pad_img(i : i+filter_size-1, j : j+filter_size-1)).* mask)
			filter_img(i, j) = sum(sum_1D);
		end
	end
end

filter_img = uint8(filter_img);
end

