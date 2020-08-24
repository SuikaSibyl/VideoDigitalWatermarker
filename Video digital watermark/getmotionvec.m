function[mpeg,emb]=getmotionvec(mpeg,mb,pf,pfy,x,y)
%ֻ�Ժ��ĵ�һά���ݽ��д���
mby=mb(:,:,1);  %��ȡ���yֵ
[M,N]=size(pfy);    %�ο�֡����
%����������
step=8;
%[dx,dy]��ʾ������9������������
%[ԭ�㡢�ҷ������ϡ��Ϸ������ϡ��󷽡����¡��·�������]
dx=[0 1 1 0 -1 -1 -1 0 1];
dy=[0 0 1 1 1 0 -1 -1 -1];
mvx=0;
mvy=0;
while step>=1
    %��ʼ���жϲ�����С���ֵΪ�����
    minsad=inf;
    for i=1:length(dx)
        tx=x+mvx+dx(i)*step;
        if(tx(1)<1||(M<tx(end)))
            continue
        end
        ty=y+mvy+dy(i)*step;
        if(ty(1)<1)||(N<ty(end))
            continue
        end
        %ͳ�Ʋв�ֵ������Ӧ���Ķ�ӦԪ�صĲ�ֵ����ֵ�ĺ�
        sad=sum(sum(abs(mby-pfy(tx,ty))));
        %���µ���С�в�ֵ�ҵ�ʱ��¼��ֵ������¼�˵��λ��
        if sad<minsad
            ii=i;
            minsad=sad;
        end
    end
    %�õ��˲����µ��˶�ʸ��ֵ
    mvx=mvx+dx(ii)*step;
    mvy=mvy+dy(ii)*step;
    step=step/2;
end
    mpeg.mvx=mvx;
    mpeg.mvy=mvy;
    %���в���󷵻ظ�emb���
    emb=mb-pf(x+mvx,y+mvy,:);
end
