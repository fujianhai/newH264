ps=imread('Ped_420_384X28812.jpg'); %��ȡͼ��
%subplot(1,3,1)
imshow(ps);
title('ԭͼ��');
ps=rgb2gray(ps);
[m,n]=size(ps); %��Sobel΢�����ӽ��б�Ե���
pa = edge(ps,'canny');
%subplot(1,3,2);
imshow(pa);
title('Canny��Ե���õ���ͼ��');