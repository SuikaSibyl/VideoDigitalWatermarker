function playlast(n)
if n==1
%如果输入的参数为[],则播放默认的fps为22
load orimov;
load water_mov;
wmov=getmov(w_mov,0);
for i=1:size(orimov,4)
    %将编解码前后视频的数据并排排列
    m(i).cdata=uint8([orimov(:,:,:,i) wmov(:,:,:,i)]);
    m(i).colormap=[];
end
%调用函数figuresc（）设定播放窗口的长度与宽度
%figuresc([0.9 0.4])
mplay(m,22)
end

if n==2
load compr;
load water_mov;
wmov=getmov(w_mov,0);
cmov=getmov(compr,0);
for i=1:size(wmov,4)
    %将编解码前后视频的数据并排排列
    m(i).cdata=uint8([wmov(:,:,:,i) cmov(:,:,:,i)]);
    m(i).colormap=[];
end
%调用函数figuresc（）设定播放窗口的长度与宽度
%figuresc([0.9 0.4])
mplay(m,22)
end
end