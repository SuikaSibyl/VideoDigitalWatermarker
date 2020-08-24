function[A]=psnr(image_orig,image_copy)
% image_orig:ԭͼ��
% image_copy:ˮӡǶ����ͼ��Ҫ��ˮӡǶ��ǰ��ͼ�������ͬ��ά��
image_orig=double(image_orig);
image_copy=double(image_copy);
[M,N]=size(image_orig);
[m,n]=size(image_copy);
if((sum(sum(image_orig-image_copy)))==0|(M~=m)|(N~=n))
    error('Input vectors must no be identical')
else
    psnr_num=M*N*max(max(image_copy.^2));
    psnr_den=sum(sum((image_orig-image_copy).^2));
    A=psnr_num/psnr_den;
    A=10*log10(A);
end
end