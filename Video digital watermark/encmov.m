function mpeg=encmov(MOV)
    %函数对视频进行MPEG-2编码，生成编码后的视频mpeg。用到的视频帧GOP类型为IPPPP
    %当视频帧数超过5时，模式循环。
    fpat='IPPPP';
    k=0;
    pf=[];
    for i=1:size(MOV,4) %对视频每一帧操作
        f=MOV(:,:,:,i);
        f=double(rgb2ycbcr(f));
        k=k+1;
        if k>length(fpat)   %每5帧一个循环
            k=1;
        end
        ftype=fpat(k);
        %根据帧的类型进行不同种类的处理
        %对当前帧进行帧编码，利用函数encframe(),返回经MPEG-2编码后的视频
        %并更新下一帧作为参考帧数据pf
        [mpeg{i},pf]=encframe(f,ftype,pf);%处理该帧，参数f:该帧，ftype帧类型，pf参考帧
        h=waitbar(i/(size(MOV,4)));
    end
    close(h);
end

function[mpeg,df]=encframe(f,ftype,pf)
%对帧进行MPEG-2编码，生成编码后的帧mpeg，并得到下一帧的参考帧数据df
%输入的数据包括当前视频帧的数据矩阵f，帧的类型ftype以及参考帧的数据pf
%分别将视频帧的数据矩阵f的维数付给M,N,i
[M,N,i]=size(f);
mbsize=[M,N]/16;
%定义结构type帧类型，mvx运动向量横坐标，mvy运动向量纵坐标，scale量化位数，coef量化后数据矩阵
mpeg=struct('type',[],'mvx',[],'mvy',[],'scale',[],'coef',[]);
mpeg(mbsize(1),mbsize(2)).type=[]; %把mpeg大小变为M*N，即每个宏块一个信息
pfy=pf(:,:,1);  %pfy为参考帧的明度信息
df=zeros(size(f));
%m控制待编码视频帧行的宏块个数（1：M/16）
%n控制待编码视频帧列的宏块个数（1：N/16）
%由于需要赋值mn，遍历比blkproc函数更加方便易读
for m=1:mbsize(1)
    for n=1:mbsize(2)
        %x表示代编码宏块像素的横坐标范围
        x=16*(m-1)+1:16*(m-1)+16;
        %y表示代编码宏块像素的纵坐标范围
        y=16*(n-1)+1:16*(n-1)+16;
        %调用函数encmacroblock()对宏块进行编码
        [mpeg(m,n),df(x,y,:)]=encmacroblock(f(x,y,:),ftype,pf,pfy,x,y);
    end
end
end

function[mpeg,dmb]=encmacroblock(mb,ftype,pf,pfy,x,y)
    %用来对当前处理视频帧中的宏块mb进行宏块编码
    %输入参数包括有待编码的宏块数据mb，当前处理帧的类型模式ftype...
    %当前参考帧的数据pf，以及当前参考帧的第一维数据pfy，当前代编码宏块的坐标范围x，y
    %返回的数据有编码后的帧宏块mpeg的数据以及新的参考帧中的宏块数据。
    %qinter为P帧或B帧量化矩阵，为8*8矩阵每个元素为16
    qinter=repmat(4,8,8);
    %qintra为I帧量化矩阵
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
    %初始化mpeg结构
    mpeg.type='I';
    mpeg.mvx=0;
    mpeg.mvy=0;
    if ftype=='P'
        mpeg.type='P';
        %调用getmotionvec()函数获取运动矢量
        [mpeg,emb]=getmotionvec(mpeg,mb,pf,pfy,x,y);
        mb=emb; %代编码块变为残差块
        q=q2;
    else
        q=q1;
    end
    %调用getblocks（）函数取出宏块mb的亮度和色度块
    b=getblocks(mb);
    for i=6:-1:1
        mpeg.scale(i)=scale;
        %对该宏块的每一8*8的块矩阵对系数矩阵进行量化
        coef=dct2(b(:,:,i));
        %根据量化参数、量化矩阵对系数矩阵进行量化
        mpeg.coef(:,:,i)=round(8*coef./(scale*q));
    end
    %利用decmacroblock()函数解码出新的宏块为下一P帧准备
    dmb=decmacroblock(mpeg,pf,x,y);
end