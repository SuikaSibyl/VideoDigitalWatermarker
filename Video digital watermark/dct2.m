function y=dct2(x)
%�˺������þ���ĳ˷�����2D��ɢ���ұ任��Ĭ��Ϊ��8x8�Ŀ������ɢ���ұ任
persistent d
if isempty(d)
    d=dctmtx(8);%����8*8��ɢ���ұ任�õ��ľ���
end
y=d*x*d';
end