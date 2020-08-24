%clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ע�ͷ�֧��ʼ��
%%%%%%��ȡˮӡ��Ƶ%%%%%%%%%%
%load water_mov;
%%%%%%��ȡ������Ƶ%%%%%%%%%%
%Salt_and_Pepper;
%load water_salt;
%w_mov=SaltPepper;
%%%%%%��ȡ��˹��Ƶ%%%%%%%%%%
%gaussian;
%load Gaussian;
%w_mov=Gaussian;
%%%%%%��ȡ�˲���Ƶ%%%%%%%%%%
%Filter;
%load MedFilter;
%w_mov=MedFilter;
%%%%%%��ȡ������Ƶ%%%%%%%%%%
%crap;
%load Crap;
%w_mov=Crap;
%%%%%%��ȡѹ����Ƶ%%%%%%%%%%
%%%�뵥������main
%load compr;
%w_mov=compr;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ע�ͷ�֧������
load index_f;
mov_length=length(index4);
G=zeros(1,mov_length);
%��ȡԭʼˮӡ
load ind;%�漴���ҵ�˳��
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
    %4x4��άDCT
    d=dctmtx(4);
    for i=0:4:m-4
        for j=0:4:n-4
            fd(i+1:i+4,j+1:j+4)=d*(f(i+1:i+4,j+1:j+4))*d';
        end
    end
    %��ȡDCϵ��
    fdc_coef=zeros(m,n);
    for i=1:4:m-3
        for j=1:4:n-3
            fdc_coef(i,j)=fd(i,j);
        end
    end
    t=find(fdc_coef~=0);
    %DCϵ����һά
    for i=1:dc_num
        fdc_coefl(i)=fdc_coef(t(i));
    end
    %���ĸ�DCϵ��Ϊһ�飬����һάDCT�任
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
    %��ȡˮӡ
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
    subplot(1,2,1);imshow(w1);xlabel('ԭʼˮӡ');
    subplot(1,2,2);imshow(hh(:,:,:,ii));
    xlabel(sprintf('��%d֡��ȡˮӡ',index4(ii)));
end