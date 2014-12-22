myObj = VideoWriter('Walk1.avi');%初始化一个avi文件
writerObj.FrameRate = 30;
open(myObj);
for i=1:200%图像序列个数
    fname=strcat('\imgdata\',num2str(i),'.jpg');
    frame = imread(fname);
    writeVideo(myObj,frame);
end 
close(myObj);