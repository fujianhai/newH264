% 画矩形
function I = Draw_rectangle(x,y,W,H,I,thick)
R=1; G=2; B=3;
% 画出上边
I(y:y+thick-1,x:x+W,R) = 0;
I(y:y+thick-1,x:x+W,G) = 255;
I(y:y+thick-1,x:x+W,B) = 0;
% 画出下边
I(y+H-thick+1:y+H,x:x+W,R) = 0;
I(y+H-thick+1:y+H,x:x+W,G) = 255;
I(y+H-thick+1:y+H,x:x+W,B) = 0;
%画出左边
I(y:y+H,x:x+thick-1,R) = 0;
I(y:y+H,x:x+thick-1,G) = 255;
I(y:y+H,x:x+thick-1,B) = 0;
%画出右边
I(y:y+H,x+W-thick+1:x+W,R) = 0;
I(y:y+H,x+W-thick+1:x+W,G) = 255;
I(y:y+H,x+W-thick+1:x+W,B) = 0;