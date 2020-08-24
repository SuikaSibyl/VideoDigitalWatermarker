blank=10;
w1=imread('water50.bmp');    %����ˮӡͼƬ
[m1,n1]=size(w1);
W=reshape(w1,[1,m1*n1]);
water_num=length(W);
index=randperm(m1*n1);  %������Ҿ���
save ind index; %�����Ա�ˮӡ��ȡʹ��
R_W=W(index);   %�����Ҿ���ӳ��ͼƬ
%W2=reshape(R_W,m1,n1);
%imshow(W2);
load mov;
w_mov=mov;
yuv_length=size(mov,2); %�����ȡ��1/4��֡�����ˮӡ
w_f_size=floor(yuv_length/4);
index2=randperm(length(mov));
index3=index2([1:w_f_size]);
index4=sort(index3); %�����ȡ��1/4��֡������֡�ŵ�������
save index_f index4;
G=zeros(1,yuv_length);
n_c=zeros(1,w_f_size);
ps=zeros(1,w_f_size);
time=cputime;
for ii=1:w_f_size%�Ա���ȡ����֡�ֱ���д���
    frame=mov(index4(ii));  %ȡ����һ֡
    fo=frame.cdata; %ת��Ϊrgbͼ��
    fyuv=rgb2ycbcr(fo); %ת��Ϊyuvͼ��
    f=fyuv(:,:,1);  %ȡY����
    f=double(f);	
    [m,n]=size(f);
    dc_num=m*n/16;  %ͳ��dcϵ������
    %4x4��άDCT
    d=dctmtx(4);
    for i=0:4:m-4
        for j=0:4:n-4
            fd(i+1:i+4,j+1:j+4)=d*(f(i+1:i+4,j+1:j+4))*d';  %fdΪdct�����ž���
        end
    end
    %��ȡDCϵ��
    fdc_coef=zeros(m,n);
    for i=1:4:m-3
        for j=1:4:n-3
            fdc_coef(i,j)=fd(i,j);  %fdc_coefΪ�������Ľ�DCϵ������
        end
    end
    t=find(fdc_coef~=0);
    for i=1:dc_num
        fdc_coefl(i)=fdc_coef(t(i)); %fdc_coefΪ�����Ľ�DCϵ������
    end
    %���ĸ�DCϵ��Ϊһ�����һάDCT�任
    for i=0:4:dc_num-3
        one_dct(i+1:i+4)=dct(fdc_coefl(i+1:i+4));
    end
    f_dct=reshape(one_dct,[4,dc_num/4]);%f_dct���4��һ�����ʽ
    %����ÿ����������͵��ĸ�ϵ���ĺͲ�����
    for j=1:dc_num/4
        s(j)=abs(f_dct(3,j))+abs(f_dct(4,j));
    end
    [s_ii,index1]=sort(s,'ascend');%s_ii�ź����3/4ϵ��֮��
    s_i=s_ii(1:water_num);  %s_iǰwater_num��3/4ϵ����
    G(ii)=s_i(water_num); %G��ֵ����ˮӡ����������3/4ϵ����
    %�������ÿյ�
    for p=1:dc_num/4
        if(s_ii(p)>G(ii)&s_ii(p)<(G(ii)+blank)) %���û��������࣬�򰴱����Ŵ�
   %for p=water_num+1:dc_num/4
        %if(s_ii(p)<(G(ii)+blank))
            a=f_dct(3,index1(p));
            b=f_dct(4,index1(p));
            f_dct(3,index1(p))=a/s_ii(p)*(G(ii)+blank);
            f_dct(4,index1(p))=b/s_ii(p)*(G(ii)+blank);
        end
    end
    %Ƕ��ˮӡ
    for j=1:dc_num/4
        s(j)=abs(f_dct(3,j))+abs(f_dct(4,j));   %s����ֵ֮��
    end
    tt=find(s<(G(ii)+blank/2)); %ttС����ֵ����Ƕ��ı�ţ�
    for i=1:water_num
        diff(i)=f_dct(3,tt(i))-f_dct(4,tt(i));
        %�����������Ӧ����ˮӡǶ��ǿ��
        if abs(f_dct(3,tt(i)))+abs(f_dct(4,tt(i)))<10   %��ϵ������С
            dif=6;
        else
            dif=10; %��ϵ�����ϴ�
        end
        if R_W(i)==1    %ˮӡ����Ϊ1
            if diff(i)<dif  %Ŀǰϵ����С��Ŀ���
                if diff(i)<0    %ϵ��3С��4
                    f_dct(3,tt(i))=f_dct(3,tt(i))+(abs(diff(i))+dif)/2;
                    f_dct(4,tt(i))=f_dct(4,tt(i))-(abs(diff(i))+dif)/2;
                else    %ϵ��3����4
                    f_dct(3,tt(i))=f_dct(3,tt(i))+(dif-abs(diff(i)))/2;
                    f_dct(4,tt(i))=f_dct(4,tt(i))-(dif-abs(diff(i)))/2;
                end
            else    %Ŀǰϵ�������Ŀ��
                 f_dct(3,tt(i))=f_dct(3,tt(i));
                 f_dct(4,tt(i))=f_dct(4,tt(i));
            end
        else    %ˮӡ����Ϊ0
                if diff(i)>(-dif)   %ˮӡ������Ŀ����
                    if diff(i)>0
                        f_dct(3,tt(i))=f_dct(3,tt(i))-(dif+abs(diff(i)))/2;
                        f_dct(4,tt(i))=f_dct(4,tt(i))+(dif+abs(diff(i)))/2;
                    else
                        f_dct(3,tt(i))=f_dct(3,tt(i))-(dif-abs(diff(i)))/2;
                        f_dct(4,tt(i))=f_dct(4,tt(i))+(dif-abs(diff(i)))/2;
                    end
                else
                    f_dct(3,tt(i))=f_dct(3,tt(i));
                    f_dct(4,tt(i))=f_dct(4,tt(i));
                end
         end
    end
        %�ĸ�DCϵ��Ϊһ�飬��һάDCT�任
        fdct=reshape(f_dct,[1,dc_num]);
        for i=0:4:dc_num-3
            E_dc(i+1:i+4)=idct(fdct(i+1:i+4));
        end
        %DCϵ���ص�����
        for i=1:dc_num
            fd(t(i))=E_dc(i);
        end
        %��Ƕ��ˮӡ�ľ�����з���άDCT�任
        d=dctmtx(4);
        for i=0:4:m-4
            for j=0:4:n-4
                fw(i+1:i+4,j+1:j+4)=d'*(fd(i+1:i+4,j+1:j+4))*d;
            end
        end
        
    
        %��ֵ�����
        ps(ii)=psnr(f,fw);%���ú���psnr()
        fyuv(:,:,1)=fw;
        f_wimage=ycbcr2rgb(fyuv);
        w_mov(index4(ii)).cdata=f_wimage;
        n_c(ii)=nc(f_wimage,fo);
        h=waitbar(ii/w_f_size);
end
close(h)