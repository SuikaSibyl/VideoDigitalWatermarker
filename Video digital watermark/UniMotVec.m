function [MotVec_mpeg] = UniMotVec(mpeg)
%读取已编码的视频mpeg的帧数
FrameNum=size(mpeg,2);
for i=1:FrameNum
    mbsize=size(mpeg{i});
    for m=1:mbsize(1)
        for n=1:mbsize(2)
            %如果P帧且当前块的运动矢量为0，把前一帧相应块的运动矢量赋给此块
            if mpeg{i}(m,n).type=='P'
                if(mpeg{i}(m,n).mvx==0)&(mpeg{i}(m,n).mvy==0)
                    mpeg{i}(m,n).mvx=mpeg{i-1}(m,n).mvx;
                    mpeg{i}(m,n).mvy=mpeg{i-1}(m,n).mvy;
                end
            end
        end
    end
    for m=1:mbsize(1)
        for n=1:mbsize(2)
            Mvx(m,n)=mpeg{i}(m,n).mvx;
            Mvy(m,n)=mpeg{i}(m,n).mvy;
        end
    end
    %做3x3的中值滤波
    Mvx=medfilt2(Mvx,[3,3]);
    Mvy=medfilt2(Mvy,[3,3]);
    for m=1:mbsize(1)
        for n=1:mbsize(2)
            mpeg{i}(m,n).mvx=Mvx(m,n);
            mpeg{i}(m,n).mvy=Mvy(m,n);
        end
    end
end
MotVec_mpeg=mpeg;
end

