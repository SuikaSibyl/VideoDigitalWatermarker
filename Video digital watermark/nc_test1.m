load mov;
load water_mov;
orimov=getmov(mov,0);
watermov=getmov(w_mov,0);
nframe=size(orimov,4);
nc_result=zeros(nframe);
for i=1:nframe
    nc_result(i)=nc(orimov(:,:,:,i),watermov(:,:,:,i));
end
i=1:nframe;
plot(i,nc_result(i));