function mov = decmpeg(mpeg)
%movsize=[18 22]��ʾÿ֡�ĺᡢ�к����Ŀ
movsize=size(mpeg{1});
mov=repmat(uint8(0),[16*movsize(1:2),3,length(mpeg)]);
pf=[];
for i=1:length(mpeg)
    %���ú���decframe()��ÿһ֡���н���
    f=decframe(mpeg{i},pf);
    %�ѽ����ĵ�ǰ֡��Ϊ��һ֡�Ĳο�֡
    pf=f;
    f=ycbcr2rgb(uint8(f));
    f=min(max(f,0),255);
    %�����������ÿһ֡���ݸ���mov��ÿһ֡
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
        %�Ա�������Ƶ֡mpeg�еĵ�(m,n)�������н���
        fr(x,y,:)=decmacroblock(mpeg(m,n),pf,x,y);
    end
end
end
