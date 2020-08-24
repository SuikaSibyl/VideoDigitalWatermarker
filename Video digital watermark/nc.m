function[nc]=nc(image1,image2)
D=double(image1);
W=double(image2);
M=size(D,1);
N=size(D,2);
K=size(D,3);
if(M~=size(image2,1))|(N~=size(image2,2))|(K~=size(image2,3))
    diso('the two image matrix must have the same dimensions!');
else
    fz=sum(sum(reshape(D.*W,M*N,K)));
    fm1=sum(sum(reshape(D.*D,M*N,K)));
    fm2=sum(sum(reshape(W.*W,M*N,K)));
    nc=fz/sqrt(fm1*fm2);
end
return