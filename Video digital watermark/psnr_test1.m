load index_f;
load mov;
load water_mov;
commov=getmov(mov,0);
watermov=getmov(w_mov,0);
nframe=size(commov,4);
psnr_result=zeros(nframe);
for i=1:nframe/4
    commov2(:,:,:)=rgb2ycbcr(commov(:,:,:,index4(i)));
    watermov2(:,:,:)=rgb2ycbcr(watermov(:,:,:,index4(i)));
    psnr_result(i)=psnr(commov2(:,:,1),watermov2(:,:,1));
end
i=1:nframe/4;
plot(i,psnr_result(i));