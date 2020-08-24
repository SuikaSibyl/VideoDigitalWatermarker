function mpeg=encmov(MOV)
    %��������Ƶ����MPEG-2���룬���ɱ�������Ƶmpeg���õ�����Ƶ֡GOP����ΪIPPPP
    %����Ƶ֡������5ʱ��ģʽѭ����
    fpat='IPPPP';
    k=0;
    pf=[];
    for i=1:size(MOV,4) %����Ƶÿһ֡����
        f=MOV(:,:,:,i);
        f=double(rgb2ycbcr(f));
        k=k+1;
        if k>length(fpat)   %ÿ5֡һ��ѭ��
            k=1;
        end
        ftype=fpat(k);
        %����֡�����ͽ��в�ͬ����Ĵ���
        %�Ե�ǰ֡����֡���룬���ú���encframe(),���ؾ�MPEG-2��������Ƶ
        %��������һ֡��Ϊ�ο�֡����pf
        [mpeg{i},pf]=encframe(f,ftype,pf);%�����֡������f:��֡��ftype֡���ͣ�pf�ο�֡
        h=waitbar(i/(size(MOV,4)));
    end
    close(h);
end

function[mpeg,df]=encframe(f,ftype,pf)
%��֡����MPEG-2���룬���ɱ�����֡mpeg�����õ���һ֡�Ĳο�֡����df
%��������ݰ�����ǰ��Ƶ֡�����ݾ���f��֡������ftype�Լ��ο�֡������pf
%�ֱ���Ƶ֡�����ݾ���f��ά������M,N,i
[M,N,i]=size(f);
mbsize=[M,N]/16;
%����ṹtype֡���ͣ�mvx�˶����������꣬mvy�˶����������꣬scale����λ����coef���������ݾ���
mpeg=struct('type',[],'mvx',[],'mvy',[],'scale',[],'coef',[]);
mpeg(mbsize(1),mbsize(2)).type=[]; %��mpeg��С��ΪM*N����ÿ�����һ����Ϣ
pfy=pf(:,:,1);  %pfyΪ�ο�֡��������Ϣ
df=zeros(size(f));
%m���ƴ�������Ƶ֡�еĺ�������1��M/16��
%n���ƴ�������Ƶ֡�еĺ�������1��N/16��
%������Ҫ��ֵmn��������blkproc�������ӷ����׶�
for m=1:mbsize(1)
    for n=1:mbsize(2)
        %x��ʾ�����������صĺ����귶Χ
        x=16*(m-1)+1:16*(m-1)+16;
        %y��ʾ�����������ص������귶Χ
        y=16*(n-1)+1:16*(n-1)+16;
        %���ú���encmacroblock()�Ժ����б���
        [mpeg(m,n),df(x,y,:)]=encmacroblock(f(x,y,:),ftype,pf,pfy,x,y);
    end
end
end

function[mpeg,dmb]=encmacroblock(mb,ftype,pf,pfy,x,y)
    %�����Ե�ǰ������Ƶ֡�еĺ��mb���к�����
    %������������д�����ĺ������mb����ǰ����֡������ģʽftype...
    %��ǰ�ο�֡������pf���Լ���ǰ�ο�֡�ĵ�һά����pfy����ǰ������������귶Χx��y
    %���ص������б�����֡���mpeg�������Լ��µĲο�֡�еĺ�����ݡ�
    %qinterΪP֡��B֡��������Ϊ8*8����ÿ��Ԫ��Ϊ16
    qinter=repmat(4,8,8);
    %qintraΪI֡��������
    qintra=[8 16 19 22 26 27 29 34;
            16 16 22 24 27 29 34 37;
            19 22 26 27 29 34 34 38;
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
    scale=8;
    %��ʼ��mpeg�ṹ
    mpeg.type='I';
    mpeg.mvx=0;
    mpeg.mvy=0;
    if ftype=='P'
        mpeg.type='P';
        %����getmotionvec()������ȡ�˶�ʸ��
        [mpeg,emb]=getmotionvec(mpeg,mb,pf,pfy,x,y);
        mb=emb; %��������Ϊ�в��
        q=q2;
    else
        q=q1;
    end
    %����getblocks��������ȡ�����mb�����Ⱥ�ɫ�ȿ�
    b=getblocks(mb);
    for i=6:-1:1
        mpeg.scale(i)=scale;
        %�Ըú���ÿһ8*8�Ŀ�����ϵ�������������
        coef=dct2(b(:,:,i));
        %�����������������������ϵ�������������
        mpeg.coef(:,:,i)=round(8*coef./(scale*q));
    end
    %����decmacroblock()����������µĺ��Ϊ��һP֡׼��
    dmb=decmacroblock(mpeg,pf,x,y);
end