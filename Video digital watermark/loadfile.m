function mov = loadfile
%�������ڶ�����Ƶ�ļ���ת��Ϊframe�ṹ����
    video= VideoReader("kk.mp4");   %�����ļ�
    nFrames = video.NumberOfFrames;   %��ȡ��Ƶ֡��
    vidHeight = video.Height;   %��ȡ��Ƶ�߶�
    vidWidth = video.Width;   %��ȡ��Ƶ���
    for k = 1:2:nFrames
        im = read(video, k);    %��ȡÿһ֡
        im=completion(im);  %����֡ͼ������
        mov((k+1)/2)=im2frame(im);    %ת��Ϊframe�ṹ����
        h=waitbar(k/nFrames);
    end
    close(h);
end

function result=completion(img)
%�������ڰ�ͼ�񳤿�����Ϊ16�ı���
    [m,n,~]=size(img);
    m_=ceil(m/16)*16;   %����16�������ϲ���
    n_=ceil(n/16)*16;   %����16�������ϲ���
    for i=m+1:m_
        img(i,:,:)=img(m,:,:);
    end
    for j=n+1:n_
        img(:,j,:)=img(:,n,:);
    end
    result=img;
end