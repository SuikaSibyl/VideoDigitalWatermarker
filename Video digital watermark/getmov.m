function movdata = getmov(mov,nf)
%�������ڰ�frame�ṹ����ת��Ϊ�ײ�����4D-uint8(0)����
    if nf==0 %����������Ĳ���Ϊ0ʱ����ʾȡ����Ƶ��ȫ��֡��
        nf=length(mov);
    end
    %��movdata����ֵ������һ��4D��ȫuint8��0������
    %����ĸ���ά�ȷֱ�Ϊ���߶ȣ���ȣ���ɫ��֡��nf��
    movdata=repmat(uint8(0),[size(mov(1).cdata),nf]);
    %��mov�е�ǰnf֡�����ݷֱ𸳸�movdata��:,:,:,i��
    for i=1:nf
        movdata(:,:,:,i)=mov(i).cdata;
    end
end
