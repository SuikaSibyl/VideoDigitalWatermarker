function varagout=figuresc(sf)
%sf=1.0ȫ����ʾ
%sf=[x,y]����x��y��ֵ�����ɿ�����ʾ����
if any(sf<0.0)|any(sf>1)
    error('Scaling factor must be between 0,0 and 1,0');
end
if numel(sf)==1
    sf=[sf sf];
end
pos=[(1-sf)/2,sf];
f=figure('Units','Normalized','Position',pos(:));
if nargout>0
    varargout{1}=f;
end