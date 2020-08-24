load compr;
load water_mov;
commov=getmov(compr,0);
watermov=getmov(w_mov,0);
nframe=size(commov,4);
psnr_result=zeros(nframe);
for i=1:nframe
    commov2(:,:,:)=rgb2ycbcr(commov(:,:,:,i));
    watermov2(:,:,:)=rgb2ycbcr(watermov(:,:,:,i));
    psnr_result(i)=psnr(commov2(:,:,1),watermov2(:,:,1));
end
i=1:nframe;
plot(i,psnr_result(i));