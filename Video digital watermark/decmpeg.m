function mov = decmpeg(mpeg)
%movsize=[18 22]表示每帧的横、列宏块数目
movsize=size(mpeg{1});
mov=repmat(uint8(0),[16*movsize(1:2),3,length(mpeg)]);
pf=[];
for i=1:length(mpeg)
    %调用函数decframe()对每一帧进行解码
    f=decframe(mpeg{i},pf);
    %把解码后的当前帧作为下一帧的参考帧
    pf=f;
    f=ycbcr2rgb(uint8(f));
    f=min(max(f,0),255);
    %将经过解码的每一帧数据赋给mov的每一帧
    mov(:,:,:,i)=f;
    waitbar(i/length(mpeg))
end
end

function fr=decframe(mpeg,pf)
mbsize=size(mpeg);
M=16*mbsize(1);
N=16*mbsize(2);
fr=zeros(M,N,3);
for m=1:mbsize(1)
    for n=1:mbsize(2)
        x=16*(m-1)+1:16*(m-1)+16;
        y=16*(n-1)+1:16*(n-1)+16;
        %对编码后的视频帧mpeg中的第(m,n)个宏块进行解码
        fr(x,y,:)=decmacroblock(mpeg(m,n),pf,x,y);
    end
end
end
