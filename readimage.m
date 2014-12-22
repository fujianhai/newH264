% ***********************************************
% [] = readimage('',10:12,384,288)
% rows = 384;cols=288
%

function [Movie] =readimage(filename,frames,rows,cols)

fid = fopen(filename,'r');

% 设置长宽
row=rows;
col=cols;

% 获取长度
num = length(frames);

frames=10:12; % total=300

%转换Y U V 空间
Y=zeros(row,col,frames);
U=zeros(row/2,col/2,frames);
V=zeros(row/2,col/2,frames);
UU=zeros(row,col,frames);
VV=zeros(row,col,frames);

% % 转存到Movie()空间中
% Movie(1:num) = struct('cdata', zeros(col, row, 3, 'uint8'), 'colormap', []);
Movie(1:num) = zeros(1);
for frame=1:frames
[Y(:,:,frame),count] = fread(fid,[row,col],'uchar');
[U(:,:,frame),count1]=fread(fid,[row/2,col/2],'uchar');
[V(:,:,frame),count2]=fread(fid,[row/2,col/2],'uchar');
%fclose(fid) 
%[Y,U,V]=Set_yuv(Y,U,V,156,152,frame);
%figure,imshow(Y);

UU(1:2:row-1,1:2:col-1,frame)=U(:,:,frame);
UU(1:2:row-1,2:2:col,frame)=U(:,:,frame);
UU(2:2:row,1:2:col-1,frame)=U(:,:,frame);
UU(2:2:row,2:2:col,frame)=U(:,:,frame);

VV(1:2:row-1,1:2:col-1,frame)=V(:,:,frame);
VV(1:2:row-1,2:2:col,frame)=V(:,:,frame);
VV(2:2:row,1:2:col-1,frame)=V(:,:,frame);
VV(2:2:row,2:2:col,frame)=V(:,:,frame);

R = Y + 1.140 * (VV-128 );
G = Y + 0.395 * (UU-128 ) - 0.581 *(VV-128);
B = Y + 2.032 *(UU-128);

for i=1:row
  for j=1:col
    if R(i,j,frame)<0
        R(i,j,frame)=0;
    end
    if R(i,j,frame)>255
        R(i,j,frame)=255;
    end
    if G(i,j,frame)<0
        G(i,j,frame)=0;
    end
    if G(i,j,frame)>255
        G(i,j,frame)=255;
    end
    if B(i,j,frame)<0
        B(i,j,frame)=0;
    end
    if B(i,j,frame)>255
        B(i,j,frame)=255;
    end
   end
end

% 转换为R、G、B空间
R=R/255;G=G/255;B=B/255;
images(:,:,1)=R(:,:,frame)';
images(:,:,2)=G(:,:,frame)';
images(:,:,3)=B(:,:,frame)';

%每次处理一张图片 cdata
figure,imshow(images)
imwrite(images,['./imge',num2str(frame), '.jpg'])
% M(frame) =im2frame(X,map);
end