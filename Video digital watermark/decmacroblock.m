function mb=decmacroblock(mpeg,pf,x,y)
%函数利用当前参考帧对当前编码后的宏块进行解码，
%得到新的参考帧宏块数据，也即当前帧经过运动矢量估计与运动补偿之后得到的当前帧近似估计值
    %量化矩阵
    qinter=repmat(4,8,8);
    qintra=[8 16 19 22 26 27 29 34;
        16 16 22 24 27 29 34 37;
        19 22 24 26 27 29 34 37;
        22 22 26 27 29 34 37 40;
        22 26 27 29 32 35 40 48;
        26 27 29 32 35 40 48 58;
        26 27 29 34 38 46 56 69;
        27 29 35 38 46 56 69 83];
    persistent q1 q2
    if isempty(q1)
        q1=qintra;
        q2=qinter;
    end
    mb=zeros(16,16,3);
    %如果为P帧，现置为参考帧加矢量
    if mpeg.type=='P'
        mb=pf(x+mpeg.mvx,y+mpeg.mvy,:);
        q=q2;
    else
        q=q1;
    end
    for i=6:-1:1
        coef=mpeg.coef(:,:,i).*(mpeg.scale(i)*q)/8;
        b(:,:,i)=idct2(coef);
    end
    %补齐残差
    mb=mb+putblocks(b);
end
        