clear
load water_mov;
nf=size(w_mov,2);
width=40;
wid=width/2;
for i=1:nf
    frame=w_mov(i).cdata;
    frame(320-wid:320+wid,180-wid:180+wid,:)=0;
    Crap(i)=im2frame(frame);
end
save Crap Crap