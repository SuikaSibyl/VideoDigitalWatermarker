clear
load water_mov;
nf=size(w_mov,2);
Gaussian=w_mov;
for i=1:nf
    frame=w_mov(i).cdata;
    fnoise=imnoise(frame,'gaussian',0,0.0001);
    Gaussian(i)=im2frame(fnoise);
end
save Gaussian Gaussian