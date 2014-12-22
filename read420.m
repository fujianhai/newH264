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
im_size      = rows*cols*3/2;                           %��������ͼƬsize,�Ŵ�Ϊԭ����1.5��

fp = fopen(filename,'rb','b');                          % "Big-endian" byte order.

if (fp<0)                                               % �������ļ����׳�error
   error(['Cannot open ' filename '.']);
end

num = length(frameno);
Y   = cell(1, num);                                     % ��������Cell����С����num
Cb  = cell(1, num);
Cr  = cell(1, num);

for(i = 1:num)
	fseek(fp, 0, 'bof');                                % fseek()��λ������'bof' begining of file ��λ���ļ����ͷ
   
    offset = headerlength + (frameno(i)-1) * im_size;   % ��ȡoffsetƫ�������ƶ����ֽ���
	status = fseek(fp, offset, 'bof');                  % status ����״̬����λ�ɹ�����0����λʧ�ܷ���-1
	if (status<0)                                       % status <0 û�гɹ���λ���׳�error
        error(['Error in seeking image no: ' frameno(i) '.']);
	end

   lu_data = fread(fp, rows*cols, 'uchar');             % fread(fid,size,precision)���ն�������ʽ��ȡ�ļ�������Ϊ'uchar' 8λ ,sizeΪrows*cols,������������������ͬ     
   cb_data = fread(fp, rows*cols/4, 'uchar');
   cr_data = fread(fp, rows*cols/4, 'uchar');
   
   temp_data = reshape(lu_data, [cols, rows]);          %reshape()�ı�������״�����ǲ��ı�Ԫ�ظ���, �ٸ����ӣ�ԭ����2*3 2��3�й���6��Ԫ�أ����ڱ�� 3*2 �������� ����������Ԫ��
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