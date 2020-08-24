%clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%注释分支开始处
%%%%%%读取水印视频%%%%%%%%%%
%load water_mov;
%%%%%%读取椒盐视频%%%%%%%%%%
%Salt_and_Pepper;
%load water_salt;
%w_mov=SaltPepper;
%%%%%%读取高斯视频%%%%%%%%%%
%gaussian;
%load Gaussian;
%w_mov=Gaussian;
%%%%%%读取滤波视频%%%%%%%%%%
%Filter;
%load MedFilter;
%w_mov=MedFilter;
%%%%%%读取剪切视频%%%%%%%%%%
%crap;
%load Crap;
%w_mov=Crap;
%%%%%%读取压缩视频%%%%%%%%%%
%%%请单独运行main
%load compr;
%w_mov=compr;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%注释分支结束处
load index_f;
mov_length=length(index4);
G=zeros(1,mov_length);
%读取原始水印
load ind;%随即置乱的顺序
w1=imread('water50.bmp');
[m1,n1]=size(w1);
water_num=m1*n1;
n_c=zeros(1,mov_length);
for ii=1:mov_length
    fl=w_mov(index4(ii)).cdata;
    fyuv=rgb2ycbcr(fl);
    f=fyuv(:,:,1);
    f=double(f);
    [m,n]=size(f);
    dc_num=m*n/16;
    %4x4二维DCT
    d=dctmtx(4);
    for i=0:4:m-4
        for j=0:4:n-4
            fd(i+1:i+4,j+1:j+4)=d*(f(i+1:i+4,j+1:j+4))*d';
        end
    end
    %提取DC系数
    fdc_coef=zeros(m,n);
    for i=1:4:m-3
        for j=1:4:n-3
            fdc_coef(i,j)=fd(i,j);
        end
    end
    t=find(fdc_coef~=0);
    %DC系数成一维
    for i=1:dc_num
        fdc_coefl(i)=fdc_coef(t(i));
    end
    %以四个DC系数为一组，进行一维DCT变换
    for i=0:4:dc_num-3
        f_dctl(i+1:i+4)=dct(fdc_coefl(i+1:i+4));
    end
    fdct=reshape(f_dctl,[4,dc_num/4]);
    for j=1:dc_num/4
        s(j)=abs(fdct(3,j))+abs(fdct(4,j));
    end
    [s_i,index2]=sort(s,'ascend');
    G(ii)=s_i(water_num);
    tw=find(s<G(ii)|s==G(ii));
    %提取水印
    for i=1:water_num
        diff(i)=fdct(3,tw(i))-fdct(4,tw(i));
        if diff(i)>0
            w(i)=1;
        else
            w(i)=0;
        end
    end
    [p ind2]=sort(index);
    W=w(ind2);
    extract_w=reshape(W,[m1 n1]);
    hh(:,:,:,ii)=extract_w;
      h=waitbar(ii/mov_length);
end
for ii=1:mov_length
    figure;
    subplot(1,2,1);imshow(w1);xlabel('原始水印');
    subplot(1,2,2);imshow(hh(:,:,:,ii));
    xlabel(sprintf('第%d帧提取水印',index4(ii)));
end