myObj = VideoWriter('Walk1.avi');%��ʼ��һ��avi�ļ�
writerObj.FrameRate = 30;
open(myObj);
for i=1:200%ͼ�����и���
    fname=strcat('\imgdata\',num2str(i),'.jpg');
    frame = imread(fname);
    writeVideo(myObj,frame);
end 
close(myObj);