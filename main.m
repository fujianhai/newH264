clear all
close all

%% ������Ƶ
path = 'walk1.avi';

% Movie = readimage(path,10:12,384,288);


tic
imgs = mmreader(path);
Length = imgs.NumberOfFrames;
height = imgs.Height;
width = imgs.Width;
Movie(1:Length) = struct('cdata', zeros(height, width, 3, 'uint8'), 'colormap', []);
toc

%ÿ�ζ�ȡһ��ͼƬ
for i=1:Length
    Movie(i).cdata = read(imgs,i);
end



%% ���ñ���
% ��һ֡ͼƬ
index_start = 1; 
% ���ƶ���ֵ
f_thresh = 0.16;
% ������������
max_it = 5;

%% ѡ���η���

I=Movie(1).cdata;
height = size(I,1);
width = size(I,2);

% ����figure����Ļ��λ�ã�����ȥ��x��y��������
scrsz = get(0,'ScreenSize');
figure (2)
set(2,'Name','����Ŀ��','Position',...
    [scrsz(3)/2-width/2 scrsz(4)/2-height/2 width height],...
    'MenuBar','none');
axis off
set(gca,'Units','pixels','Position',[1 1 width height])

imshow(I);
% �������ο򣬵õ��������Ͻ�����A(x,y)�����rect(3),�߶�rect(4) 
rect = getrect;
rect = floor(rect);

x0 = rect(1);
y0 = rect(2);
W = rect(3);
H = rect(4);

% T ������ľ��δ�С size
T = I(y0:y0+H-1,x0:x0+W-1,:);

% Canny����
ps = rgb2gray(T);
[m,n] = size(ps);
pa = edge(ps,'canny');
% ת��Ϊ������ 1*(m*n)
pa = reshape(pa,m*n,1);

disp('==========Cany======');
size(pa)
disp('==========T==========');
size(T)

close (2)
% ��ͣһ��
pause(0.2);

%% ���� Mean-Shift �㷨
% H ,W ��size
k=zeros(H,W);
sigmaH = (H/2)/3;
sigmaW = (W/2)/3;
for i=1:H
    for j=1:W
        k(i,j) = exp(-.5*((i-.5*H)^2/sigmaH^2+...
            (j-.5*W)^2/sigmaW^2));
    end
end
% gx ,gy ���ݶ�
[gx,gy] = gradient(-k);


% �����ɫͼ��ת��Ϊ����ͼ��RGBͼ��ռ�����ֽڣ��ֱ�洢R\G\B������ֵ
% [X,map] = rgb2ind(RGB,n) nΪָ����map����ɫ��������������Ϊ���ֵ65536
[I,map] = rgb2ind(Movie(index_start).cdata,65536);
Lmap = length(map)+1;
T = rgb2ind(T,map);

%% ������ɫֱ��ͼ�ܶ�

q = zeros(Lmap,1);
size(q)
colour = linspace(1,Lmap,Lmap);

for x=1:W
    for y=1:H 
        q(T(y,x)+1) = q(T(y,x)+1)+k(y,x);
    end
end

% ��һ������
C = 1/sum(sum(k));

q = C.*q;
% �ϲ���ɫֱ��ͼ����������
q = [q;pa];
disp('====q=======');
size(q)


%%
% Ŀ����ʧ�������flag
loss = 0;
f = zeros(1,(Length-1)*max_it);
f_indx = 1;

% �ڵ�һ֡�������ο�
Movie(index_start).cdata = Draw_rectangle(x0,y0,W,H,...
    Movie(index_start).cdata,2);

%��Ӹ�������
WaitBar = waitbar(0,'���ڴ���, �Ե�...');

for t=1:Length-1
    I2 = rgb2ind(Movie(t+1).cdata,map);
    % �������ļ�֡
    [x,y,loss,f,f_indx] = MeanShift_Tracking(q,I2,Lmap,...
        height,width,f_thresh,max_it,x0,y0,H,W,k,gx,...
        gy,f,f_indx,loss);
    % ���loss����Ƿ�Ϊ1�����Ϊ���������
    if loss == 1
        break;
    else
        % ���û�н����ͻ������ο�
        Movie(t+1).cdata = Draw_rectangle(x,y,W,H,Movie(t+1).cdata,2);
        
        % ��һ֡��Ϊ��ǰ֡
        y0 = y;
        x0 = x;
        % ���½�����
        waitbar(t/(Length-1));
    end
end
close(WaitBar);

% ����figure��û������Ͳ˵���
scrsz = get(0,'ScreenSize');
figure(1)
set(1,'Name','Ŀ�����','Position',...
    [scrsz(3)/2-width/2 scrsz(4)/2-height/2 width height],...
    'MenuBar','none');
axis off
set(gca,'Units','pixels','Position',[1 1 width height])
% ����movie
movie(Movie);