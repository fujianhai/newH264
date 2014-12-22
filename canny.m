ps=imread('Ped_420_384X28812.jpg'); %读取图像
%subplot(1,3,1)
imshow(ps);
title('原图像');
ps=rgb2gray(ps);
[m,n]=size(ps); %用Sobel微分算子进行边缘检测
pa = edge(ps,'canny');
%subplot(1,3,2);
imshow(pa);
title('Canny边缘检测得到的图像');