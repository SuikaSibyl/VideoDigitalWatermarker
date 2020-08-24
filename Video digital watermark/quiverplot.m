function quiverplot(mpeg,n)
[M,N]=size(mpeg{1});
for f=1:n
    %���ΪI֡������ѭ�����������˶�ʸ��ͼ
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
    %����ÿһ֡���˶�ʸ��ͼ
    quiver(flipud(mvx),flipud(mvy))
    set(gca,'XLim',[-1,N+2],'YLim',[-1,M+2])
    title(sprintf('Motion vectors for frame %i',f))
end