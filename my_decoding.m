function img = my_decoding(zigzag,row,col)
% Compress Image using portion of JPEG
% zigzag : result of zigzag scanning
% img    : GrayScale Image

% 1. Construct 8x8 blocks using zigzag scanning value
% 2. Multiply Quantization Table
% 3. Apply Inverse DCT
% 4. Add 128
