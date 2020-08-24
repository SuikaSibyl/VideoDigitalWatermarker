function quiverplot(mpeg,n)
[M,N]=size(mpeg{1});
for f=1:n
    %如果为I帧则跳出循环，即不画运动矢量图
    if mpeg{f}(1,1).type=='I'
        continue
    end
    for i=1:M
        for j=1:N
            mvx(i,j)=mpeg{f}(i,j).mvy;
            mvy(i,j)=mpeg{f}(i,j).mvx;
        end
    end
    figuresc(0.8)
    %绘制每一帧的运动矢量图
    quiver(flipud(mvx),flipud(mvy))
    set(gca,'XLim',[-1,N+2],'YLim',[-1,M+2])
    title(sprintf('Motion vectors for frame %i',f))
end