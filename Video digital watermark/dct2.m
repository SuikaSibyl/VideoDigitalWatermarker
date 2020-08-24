function y=dct2(x)
%此函数利用矩阵的乘法进行2D离散余弦变换，默认为对8x8的块进行离散余弦变换
persistent d
if isempty(d)
    d=dctmtx(8);%进行8*8离散余弦变换用到的矩阵
end
y=d*x*d';
end