clear
load water_mov;
nf=size(w_mov,2);
SaltPepper=w_mov;
for i=1:nf
    frame=w_mov(i).cdata;
    fnoise=imnoise(frame,'salt & pepper',0.0001);
    SaltPepper(i)=im2frame(fnoise);
end
save water_salt SaltPepper