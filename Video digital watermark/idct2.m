function y=idct2(x)
%2D��ɢ���ҷ��任
persistent d
if isempty(d)
    d=dctmtx(8);
end
y=d'*x*d;
end
