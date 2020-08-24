function[mpeg,emb]=getmotionvec(mpeg,mb,pf,pfy,x,y)
%只对宏块的第一维数据进行处理
mby=mb(:,:,1);  %获取宏块y值
[M,N]=size(pfy);    %参考帧长宽
%对数搜索法
step=8;
%[dx,dy]表示待处理9个点的相对坐标
%[原点、右方、右上、上方、左上、左方、左下、下方、右下]
dx=[0 1 1 0 -1 -1 -1 0 1];
dy=[0 0 1 1 1 0 -1 -1 -1];
mvx=0;
mvy=0;
while step>=1
    %初始化判断参数最小误差值为无穷大
    minsad=inf;
    for i=1:length(dx)
        tx=x+mvx+dx(i)*step;
        if(tx(1)<1||(M<tx(end)))
            continue
        end
        ty=y+mvy+dy(i)*step;
        if(ty(1)<1)||(N<ty(end))
            continue
        end
        %统计残差值，即相应宏块的对应元素的差值绝对值的和
        sad=sum(sum(abs(mby-pfy(tx,ty))));
        %当新的最小残差值找到时记录此值，并记录此点的位置
        if sad<minsad
            ii=i;
            minsad=sad;
        end
    end
    %得到此步长下的运动矢量值
    mvx=mvx+dx(ii)*step;
    mvy=mvy+dy(ii)*step;
    step=step/2;
end
    mpeg.mvx=mvx;
    mpeg.mvy=mvy;
    %宏块残差矩阵返回给emb输出
    emb=mb-pf(x+mvx,y+mvy,:);
end
