function [zigzag, row, col] = my_encoding(img)
% Compress Image using portion of JPEG
% img    : GrayScale Image
% zigzag : result of zigzag scanning

% we follow the next seq.
% 1. initialized value
[row,col] = size(img);
img = double(img); 
x = row;    
y = col;    
N = 8;

% 2. Subtract 128
sub_img = img - 128;

% 3. Apply DCT
if mod(row,8) ~= 0
  x = row + 8 - mod(row,8);
end
if mod(col,8) ~= 0
  y = col + 8 - mod(col,8);
end
after_img = zeros(x,y);
after_img(1:row,1:col) = sub_img(1:row, 1:col);  


block_after = zeros(N);

C_uv = 2/N*ones(N);
C_uv(1, 1) = C_uv(1, 1)/2;
C_uv(2:N, 1) = C_uv(2:N, 1) * sqrt(2)/2;
C_uv(1, 2:N) = C_uv(1, 2:N) * sqrt(2)/2;

for i = 1 : N : row
  for j = 1 : N : col
      
    block_before = after_img(i:i+N-1,j:j+N-1);
    for u = 0 : N - 1
      for v = 0 : N - 1

        f_block = 0;
        for a = 0 : N - 1
          for b = 0 : N - 1
              cosValue = cos((((2*a)+1)*u*pi)/(2*N)) * cos((((2*b)+1)*v*pi)/(2*N));
              temp = block_before(a+1,b+1) * cosValue;
              f_block = f_block + temp; 
          end
        end
        
        block_after(u+1,v+1) = C_uv(u+1, v+1) * f_block;
      end
    end
    
    after_img(i:i+N-1,j:j+N-1) = block_after(1:N,1:N);
  end
end

% 4. Quantize Image using Qunatization Table
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
    after_img(i:i+N-1,j:j+N-1) = after_img(i:i+N-1,j:j+N-1) ./tableOfLuminance;
  end
end

% 5. Zigzag scanning
