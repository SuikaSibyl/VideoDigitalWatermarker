load compr;
load water_mov;
commov=getmov(compr,0);
watermov=getmov(w_mov,0);
nframe=size(commov,4);
nc_result=zeros(nframe);
for i=1:nframe
    nc_result(i)=nc(commov(:,:,:,i),watermov(:,:,:,i));
end
i=1:nframe;
plot(i,nc_result(i));