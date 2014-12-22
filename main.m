clear all
close all

%% 加载视频
path = 'walk1.avi';

% Movie = readimage(path,10:12,384,288);


tic
imgs = mmreader(path);
Length = imgs.NumberOfFrames;
height = imgs.Height;
width = imgs.Width;
Movie(1:Length) = struct('cdata', zeros(height, width, 3, 'uint8'), 'colormap', []);
toc

%每次读取一张图片
for i=1:Length
    Movie(i).cdata = read(imgs,i);
end



%% 设置变量
% 第一帧图片
index_start = 1; 
% 相似度阈值
f_thresh = 0.16;
% 迭代的最大次数
max_it = 5;

%% 选矩形方框

I=Movie(1).cdata;
height = size(I,1);
width = size(I,2);

% 设置figure在屏幕的位置，还有去掉x、y轴坐标轴
scrsz = get(0,'ScreenSize');
figure (2)
set(2,'Name','请框出目标','Position',...
    [scrsz(3)/2-width/2 scrsz(4)/2-height/2 width height],...
    'MenuBar','none');
axis off
set(gca,'Units','pixels','Position',[1 1 width height])

imshow(I);
% 画出矩形框，得到坐标左上角坐标A(x,y)，宽度rect(3),高度rect(4) 
rect = getrect;
rect = floor(rect);

x0 = rect(1);
y0 = rect(2);
W = rect(3);
H = rect(4);

% T 框出来的矩形大小 size
T = I(y0:y0+H-1,x0:x0+W-1,:);

% Canny算子
ps = rgb2gray(T);
[m,n] = size(ps);
pa = edge(ps,'canny');
% 转换为行向量 1*(m*n)
pa = reshape(pa,m*n,1);

disp('==========Cany======');
size(pa)
disp('==========T==========');
size(T)

close (2)
% 暂停一下
pause(0.2);

%% 运行 Mean-Shift 算法
% H ,W 是size
k=zeros(H,W);
sigmaH = (H/2)/3;
sigmaW = (W/2)/3;
for i=1:H
    for j=1:W
        k(i,j) = exp(-.5*((i-.5*H)^2/sigmaH^2+...
            (j-.5*W)^2/sigmaW^2));
    end
end
% gx ,gy 是梯度
[gx,gy] = gradient(-k);


% 将真彩色图像转换为索引图像，RGB图像占三个字节，分别存储R\G\B分量的值
% [X,map] = rgb2ind(RGB,n) n为指定的map中颜色项数，这里设置为最大值65536
[I,map] = rgb2ind(Movie(index_start).cdata,65536);
Lmap = length(map)+1;
T = rgb2ind(T,map);

%% 估计颜色直方图密度

q = zeros(Lmap,1);
size(q)
colour = linspace(1,Lmap,Lmap);

for x=1:W
    for y=1:H 
        q(T(y,x)+1) = q(T(y,x)+1)+k(y,x);
    end
end

% 归一化处理
C = 1/sum(sum(k));

q = C.*q;
% 合并颜色直方图和纹理特征
q = [q;pa];
disp('====q=======');
size(q)


%%
% 目标损失函数标记flag
loss = 0;
f = zeros(1,(Length-1)*max_it);
f_indx = 1;

% 在第一帧画出矩形框
Movie(index_start).cdata = Draw_rectangle(x0,y0,W,H,...
    Movie(index_start).cdata,2);

%添加个进度条
WaitBar = waitbar(0,'正在处理, 稍等...');

for t=1:Length-1
    I2 = rgb2ind(Movie(t+1).cdata,map);
    % 计算后面的几帧
    [x,y,loss,f,f_indx] = MeanShift_Tracking(q,I2,Lmap,...
        height,width,f_thresh,max_it,x0,y0,H,W,k,gx,...
        gy,f,f_indx,loss);
    % 检查loss标记是否为1，如果为真结束跟踪
    if loss == 1
        break;
    else
        % 如果没有结束就画出矩形框
        Movie(t+1).cdata = Draw_rectangle(x,y,W,H,Movie(t+1).cdata,2);
        
        % 下一帧变为当前帧
        y0 = y;
        x0 = x;
        % 更新进度条
        waitbar(t/(Length-1));
    end
end
close(WaitBar);

% 设置figure，没有坐标和菜单栏
scrsz = get(0,'ScreenSize');
figure(1)
set(1,'Name','目标跟踪','Position',...
    [scrsz(3)/2-width/2 scrsz(4)/2-height/2 width height],...
    'MenuBar','none');
axis off
set(gca,'Units','pixels','Position',[1 1 width height])
% 运行movie
movie(Movie);