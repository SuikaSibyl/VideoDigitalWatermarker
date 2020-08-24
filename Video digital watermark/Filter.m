clear
load water_mov;
nf=size(w_mov,2);
MedFilter=w_mov;
for i=1:nf
    frame=w_mov(i).cdata;
    g1=medfilt2(frame(:,:,1));%%╨Л
    g2=medfilt2(frame(:,:,2));%%бл
    g3=medfilt2(frame(:,:,3));%%ю╤
    g(:,:,1)=g1;
    g(:,:,2)=g2;
    g(:,:,3)=g3;
    MedFilter(i)=im2frame(g);
end
save  MedFilter  MedFilter