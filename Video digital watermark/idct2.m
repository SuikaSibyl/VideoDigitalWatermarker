function y=idct2(x)
%2D¿Î…¢”‡œ“∑¥±‰ªª
persistent d
if isempty(d)
    d=dctmtx(8);
end
y=d'*x*d;
end
