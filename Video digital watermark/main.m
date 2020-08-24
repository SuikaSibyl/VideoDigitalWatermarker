% mov=loadfile;
% save mov mov;
% clear

load water_mov;
orimov=getmov(w_mov,0);
save orimov orimov
clear;

load orimov;
mpeg=encmov(orimov);
save mpeg mpeg;
clear;

load mpeg;
decmov=decmpeg(mpeg);
save decmov decmov;
clear;

load decmov
l=size(decmov,4);
 for k = 1:1:l
        compr(k)=im2frame(decmov(:,:,:,k));    %转化为frame结构数组
        h=waitbar(k/l);
 end
 save compr compr;
%playlast(22);
%v = VideoWriter('newfile.avi');
%open(v)
%writeVideo(v,decmov)
%close(v)