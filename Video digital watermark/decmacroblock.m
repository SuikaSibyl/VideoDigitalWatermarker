function mb=decmacroblock(mpeg,pf,x,y)
%�������õ�ǰ�ο�֡�Ե�ǰ�����ĺ����н��룬
%�õ��µĲο�֡������ݣ�Ҳ����ǰ֡�����˶�ʸ���������˶�����֮��õ��ĵ�ǰ֡���ƹ���ֵ
    %��������
    qinter=repmat(4,8,8);
    qintra=[8 16 19 22 26 27 29 34;
        16 16 22 24 27 29 34 37;
        19 22 24 26 27 29 34 37;
        22 22 26 27 29 34 37 40;
        22 26 27 29 32 35 40 48;
        26 27 29 32 35 40 48 58;
        26 27 29 34 38 46 56 69;
        27 29 35 38 46 56 69 83];
    persistent q1 q2
    if isempty(q1)
        q1=qintra;
        q2=qinter;
    end
    mb=zeros(16,16,3);
    %���ΪP֡������Ϊ�ο�֡��ʸ��
    if mpeg.type=='P'
        mb=pf(x+mpeg.mvx,y+mpeg.mvy,:);
        q=q2;
    else
        q=q1;
    end
    for i=6:-1:1
        coef=mpeg.coef(:,:,i).*(mpeg.scale(i)*q)/8;
        b(:,:,i)=idct2(coef);
    end
    %����в�
    mb=mb+putblocks(b);
end
        