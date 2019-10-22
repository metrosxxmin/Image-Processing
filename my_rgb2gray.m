function output = my_rgb2gray(input)
% input	: color image
% output: gray image 

R = input(:, :, 1);
G = input(:, :, 2);
B = input(:, :, 3);

result = 0.299 * R + 0.587 * G + 0.114 * B;
