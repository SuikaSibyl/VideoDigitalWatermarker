function [MotVec_mpeg] = DenMotVec(mpeg)
%��ȡ�ѱ������Ƶmpeg��֡��
FrameNum=size(mpeg,2);
for i=1:FrameNum
    mbsize=size(mpeg{i});
    for m=1:mbsize(1)
        for n=1:mbsize(2)
            if mpeg{i}(m,n).type=='P'
                if(mpeg{i}(m,n).mvx==0)&(mpeg{i}(m,n).mvy==0)
                    mpeg{i}(m,n).mvx=mpeg{i-1}(m,n).mvx;
                    mpeg{i}(m,n).mvy=mpeg{i-1}(m,n).mvy;
                end
            end
        end
    end
    %�������˶�ʸ�������ú����ÿһ����
    for m=1:mbsize(1)
        for n=1:mbsize(2)
            x=16*(m-1)+1:16*(m-1)+16;
            y=16*(n-1)+1:16*(n=1)+16;
            Mvx(m,n)=mpeg{i}(m,n).mvx;
            Mvy(m,n)=mpeg{i}(m,n).mvy;
        end
    end
    %��3x3����ֵ�˲�
    Mvx=medfilt2(Mvx,[3,3]);
    Mvy=medfilt2(Mvy,[3,3]);
    DMotVec(:,:,1,i)=Mvx;
    DMotVec(:,:,2,i)=Mvy;
end
end
