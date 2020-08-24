blank=10;
w1=imread('water50.bmp');    %读入水印图片
[m1,n1]=size(w1);
W=reshape(w1,[1,m1*n1]);
water_num=length(W);
index=randperm(m1*n1);  %随机置乱矩阵
save ind index; %保存以备水印提取使用
R_W=W(index);   %用置乱矩阵映射图片
%W2=reshape(R_W,m1,n1);
%imshow(W2);
load mov;
w_mov=mov;
yuv_length=size(mov,2); %随机抽取了1/4的帧数添加水印
w_f_size=floor(yuv_length/4);
index2=randperm(length(mov));
index3=index2([1:w_f_size]);
index4=sort(index3); %随机抽取了1/4的帧，并按帧号递增排序
save index_f index4;
G=zeros(1,yuv_length);
n_c=zeros(1,w_f_size);
ps=zeros(1,w_f_size);
time=cputime;
for ii=1:w_f_size%对被抽取到的帧分别进行处理
    frame=mov(index4(ii));  %取出这一帧
    fo=frame.cdata; %转变为rgb图像
    fyuv=rgb2ycbcr(fo); %转变为yuv图像
    f=fyuv(:,:,1);  %取Y分量
    f=double(f);	
    [m,n]=size(f);
    dc_num=m*n/16;  %统计dc系数个数
    %4x4二维DCT
    d=dctmtx(4);
    for i=0:4:m-4
        for j=0:4:n-4
            fd(i+1:i+4,j+1:j+4)=d*(f(i+1:i+4,j+1:j+4))*d';  %fd为dct结果存放矩阵
        end
    end
    %提取DC系数
    fdc_coef=zeros(m,n);
    for i=1:4:m-3
        for j=1:4:n-3
            fdc_coef(i,j)=fd(i,j);  %fdc_coef为不连续的仅DC系数矩阵
        end
    end
    t=find(fdc_coef~=0);
    for i=1:dc_num
        fdc_coefl(i)=fdc_coef(t(i)); %fdc_coef为连续的仅DC系数矩阵
    end
    %以四个DC系数为一组进行一维DCT变换
    for i=0:4:dc_num-3
        one_dct(i+1:i+4)=dct(fdc_coefl(i+1:i+4));
    end
    f_dct=reshape(one_dct,[4,dc_num/4]);%f_dct变成4个一组的形式
    %计算每大组第三个和第四个系数的和并排序
    for j=1:dc_num/4
        s(j)=abs(f_dct(3,j))+abs(f_dct(4,j));
    end
    [s_ii,index1]=sort(s,'ascend');%s_ii排好序的3/4系数之和
    s_i=s_ii(1:water_num);  %s_i前water_num的3/4系数和
    G(ii)=s_i(water_num); %G阈值，即水印的组中最大的3/4系数和
    %往上设置空挡
    for p=1:dc_num/4
        if(s_ii(p)>G(ii)&s_ii(p)<(G(ii)+blank)) %如果没有拉开差距，则按比例放大
   %for p=water_num+1:dc_num/4
        %if(s_ii(p)<(G(ii)+blank))
            a=f_dct(3,index1(p));
            b=f_dct(4,index1(p));
            f_dct(3,index1(p))=a/s_ii(p)*(G(ii)+blank);
            f_dct(4,index1(p))=b/s_ii(p)*(G(ii)+blank);
        end
    end
    %嵌入水印
    for j=1:dc_num/4
        s(j)=abs(f_dct(3,j))+abs(f_dct(4,j));   %s绝对值之和
    end
    tt=find(s<(G(ii)+blank/2)); %tt小于阈值（待嵌入的编号）
    for i=1:water_num
        diff(i)=f_dct(3,tt(i))-f_dct(4,tt(i));
        %这里可以自适应调节水印嵌入强度
        if abs(f_dct(3,tt(i)))+abs(f_dct(4,tt(i)))<10   %两系数差距较小
            dif=6;
        else
            dif=10; %两系数差距较大
        end
        if R_W(i)==1    %水印数据为1
            if diff(i)<dif  %目前系数差小于目标差
                if diff(i)<0    %系数3小于4
                    f_dct(3,tt(i))=f_dct(3,tt(i))+(abs(diff(i))+dif)/2;
                    f_dct(4,tt(i))=f_dct(4,tt(i))-(abs(diff(i))+dif)/2;
                else    %系数3大于4
                    f_dct(3,tt(i))=f_dct(3,tt(i))+(dif-abs(diff(i)))/2;
                    f_dct(4,tt(i))=f_dct(4,tt(i))-(dif-abs(diff(i)))/2;
                end
            else    %目前系数大等于目标
                 f_dct(3,tt(i))=f_dct(3,tt(i));
                 f_dct(4,tt(i))=f_dct(4,tt(i));
            end
        else    %水印数据为0
                if diff(i)>(-dif)   %水印差距大于目标差距
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
        %四个DC系数为一组，反一维DCT变换
        fdct=reshape(f_dct,[1,dc_num]);
        for i=0:4:dc_num-3
            E_dc(i+1:i+4)=idct(fdct(i+1:i+4));
        end
        %DC系数回到矩阵
        for i=1:dc_num
            fd(t(i))=E_dc(i);
        end
        %对嵌入水印的矩阵进行反二维DCT变换
        d=dctmtx(4);
        for i=0:4:m-4
            for j=0:4:n-4
                fw(i+1:i+4,j+1:j+4)=d'*(fd(i+1:i+4,j+1:j+4))*d;
            end
        end
        
    
        %峰值信噪比
        ps(ii)=psnr(f,fw);%调用函数psnr()
        fyuv(:,:,1)=fw;
        f_wimage=ycbcr2rgb(fyuv);
        w_mov(index4(ii)).cdata=f_wimage;
        n_c(ii)=nc(f_wimage,fo);
        h=waitbar(ii/w_f_size);
end
close(h)