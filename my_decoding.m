function img = my_decoding(zigzag,row,col)
% Compress Image using portion of JPEG
% zigzag : result of zigzag scanning
% img    : GrayScale Image

% 1. Construct 8x8 blocks using zigzag scanning value


% 2. Multiply Quantization Table
tableOfLuminance = [16 11 10 16 24 40 51 61; 
                    12 12 14 19 26 58 60 55;
                    14 13 16 24 40 57 69 56; 
                    14 17 22 29 51 87 80 62;
                    18 22 37 56 68 109 103 77;
                    24 35 55 64 81 104 113 92;
                    49 64 78 87 103 121 120 101;
                    72 92 95 98 112 100 103 99];

for i = 1 : N : row
  for j = 1 : N : col
    after_img(i:i+N-1,j:j+N-1) = after_img(i:i+N-1,j:j+N-1).*tableOfLuminance(1:N,1:N);
  end
end

% 3. Apply Inverse DCT


% 4. Add 128
after_img = after_img + 128;
img = uint8(after_img);
end
