function playlast(n)
if n==1
%�������Ĳ���Ϊ[],�򲥷�Ĭ�ϵ�fpsΪ22
load orimov;
load water_mov;
wmov=getmov(w_mov,0);
for i=1:size(orimov,4)
    %�������ǰ����Ƶ�����ݲ�������
    m(i).cdata=uint8([orimov(:,:,:,i) wmov(:,:,:,i)]);
    m(i).colormap=[];
end
%���ú���figuresc�����趨���Ŵ��ڵĳ�������
%figuresc([0.9 0.4])
mplay(m,22)
end

if n==2
load compr;
load water_mov;
wmov=getmov(w_mov,0);
cmov=getmov(compr,0);
for i=1:size(wmov,4)
    %�������ǰ����Ƶ�����ݲ�������
    m(i).cdata=uint8([wmov(:,:,:,i) cmov(:,:,:,i)]);
    m(i).colormap=[];
end
%���ú���figuresc�����趨���Ŵ��ڵĳ�������
%figuresc([0.9 0.4])
mplay(m,22)
end
end