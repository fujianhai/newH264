% ********************************************************************
% Read video sequence with 4:2:0 YUV format.                         *
% frameno - The number of frames to be read.                         *
% Y, Cb, Cr - output video                                           *
% By Wei-gang Chen, Feb., 2008                                       *;
% [Y, Cb, Cr] = read420('..', 10:12, 288, 384);
% im = Y{2};
% im = Cb{1}
% ********************************************************************
function [Y, Cb, Cr] = read420(filename, frameno, rows, cols)
headerlength = 0;  %The size of the file header.
im_size      = rows*cols*3/2;                           %重新设置图片size,放大为原来的1.5倍

fp = fopen(filename,'rb','b');                          % "Big-endian" byte order.

if (fp<0)                                               % 不存在文件，抛出error
   error(['Cannot open ' filename '.']);
end

num = length(frameno);
Y   = cell(1, num);                                     % 建立三个Cell，大小都是num
Cb  = cell(1, num);
Cr  = cell(1, num);

for(i = 1:num)
	fseek(fp, 0, 'bof');                                % fseek()定位函数，'bof' begining of file 定位到文件的最开头
   
    offset = headerlength + (frameno(i)-1) * im_size;   % 获取offset偏移量，移动的字节数
	status = fseek(fp, offset, 'bof');                  % status 返回状态，定位成功返回0，定位失败返回-1
	if (status<0)                                       % status <0 没有成功定位，抛出error
        error(['Error in seeking image no: ' frameno(i) '.']);
	end

   lu_data = fread(fp, rows*cols, 'uchar');             % fread(fid,size,precision)按照二进制形式读取文件，精度为'uchar' 8位 ,size为rows*cols,构成列向量，下面相同     
   cb_data = fread(fp, rows*cols/4, 'uchar');
   cr_data = fread(fp, rows*cols/4, 'uchar');
   
   temp_data = reshape(lu_data, [cols, rows]);          %reshape()改变矩阵的形状，但是不改变元素个数, 举个例子，原来是2*3 2行3列共有6个元素，现在变成 3*2 三行两列 但还是两个元素
   Y{i}      = temp_data';
   
   temp_data = reshape(cb_data, [cols/2, rows/2]);
   Cb{i}     =temp_data';
   
   temp_data = reshape(cr_data, [cols/2, rows/2]);
   Cr{i}     = temp_data';
   
%    figure
%    
%    result_ycbcr(:,:,1) = uint8(Y{i});
%    result_ycbcr(:,:,2) = uint8(Cb{i});
%    result_ycbcr(:,:,2) = uint8(Cr{i});
%    
%    subplot(1,1,1),imshow(result_ycbcr),title('YCbCr')
end

fclose(fp);
return