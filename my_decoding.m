function img = my_decoding(zigzag,row,col)
% Compress Image using portion of JPEG
% zigzag : result of zigzag scanning
% img    : GrayScale Image
N=8;
after_img = zeros(row,col);

% 1. Construct 8x8 blocks using zigzag scanning value
count = 1;
for a = 1 : N : row
  for b = 1 : N : col
      
    temp_block = zeros(N,N);
    V = zigzag{count};
    block_row=1;	block_col=1;	block_index=1;
    
    while block_row <= N && block_col <= N
        if block_row == 1 && mod(block_row + block_col,2) == 0 && block_col ~= N
            if V(block_index) == 777
                break;
            end
            temp_block(block_row ,block_col) = V(block_index);
            block_col = block_col+1;			
            block_index = block_index+1;
		
        elseif block_row == N && mod(block_row + block_col,2) ~= 0 && block_col ~= N
            if V(block_index) == 777
                break;
            end
            temp_block(block_row ,block_col) = V(block_index);
            block_col = block_col+1;					
            block_index = block_index+1;
		
        elseif block_col == 1 && mod(block_row + block_col,2) ~= 0 && block_row ~= N
            if V(block_index) == 777
                break;
            end
            temp_block(block_row ,block_col) = V(block_index);
            block_row = block_row+1;						
            block_index = block_index+1;
	
        elseif block_col == N && mod(block_row+block_col,2) == 0 && block_row ~= N
            if V(block_index) == 777
                break;
            end
            temp_block(block_row ,block_col) = V(block_index);
            block_row = block_row+1;							
            block_index = block_index+1;
		
        elseif block_col ~= 1 && block_row ~= N && mod(block_row + block_col,2) ~= 0
            if V(block_index) == 777
                break;
            end
            temp_block(block_row ,block_col) = V(block_index);
            block_row = block_row+1;		
            block_col = block_col-1;	
            block_index = block_index+1;
		
        elseif block_row ~= 1 && block_col ~= N && mod(block_row + block_col,2) == 0
            if V(block_index) == 777
                break;
            end
            temp_block(block_row ,block_col) = V(block_index);
            block_row = block_row-1;		
            block_col = block_col+1;	
            block_index = block_index+1;
		
        elseif block_row == N && block_col == N	
            break						
        end
    end 
        after_img(a:a+N-1, b:b+N-1) = temp_block(1:N,1:N);
        count = count + 1;
  end
end

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
block_after = zeros(N);
C_uv = 2/N*ones(N);
C_uv(1, 1) = C_uv(1, 1)/2;
C_uv(2:N, 1) = C_uv(2:N, 1) * sqrt(2)/2;
C_uv(1, 2:N) = C_uv(1, 2:N) * sqrt(2)/2;

for i = 1 : N : row
  for j = 1 : N : col
      
    block = after_img(i:i+N-1,j:j+N-1);
    for u = 0 : N - 1
      for v = 0 : N - 1
          
        F_block = 0;
        for a = 0 : N - 1
          for b = 0 : N - 1
            cosValue = cos((((2*u)+1)*a*pi)/(2*N)) * cos((((2*v)+1)*b*pi)/(2*N));
            temp = block(a+1,b+1) * cosValue;
            F_block = F_block + ( C_uv(a+1, b+1) * temp);
          end
        end
        
        block_after(u+1,v+1) = F_block;
      end
    end
    
    after_img(i:i+N-1,j:j+N-1) = block_after(1:N, 1:N);
  end
end

% 4. Add 128
after_img = after_img + 128;
img = uint8(after_img);
end
