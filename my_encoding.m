function [zigzag, row, col] = my_encoding(img)
% Compress Image using portion of JPEG
% img    : GrayScale Image
% zigzag : result of zigzag scanning

% we follow the next seq.
% 1. initialized value
% 2. Subtract 128
% 3. Apply DCT
% 4. Quantize Image using Qunatization Table
% 5. Zigzag scanning
