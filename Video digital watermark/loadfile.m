function mov = loadfile
%函数用于读入视频文件并转化为frame结构数组
    video= VideoReader("kk.mp4");   %读入文件
    nFrames = video.NumberOfFrames;   %提取视频帧数
    vidHeight = video.Height;   %提取视频高度
    vidWidth = video.Width;   %提取视频宽度
    for k = 1:2:nFrames
        im = read(video, k);    %读取每一帧
        im=completion(im);  %将该帧图像扩充
        mov((k+1)/2)=im2frame(im);    %转化为frame结构数组
        h=waitbar(k/nFrames);
    end
    close(h);
end

function result=completion(img)
%函数用于把图像长宽扩充为16的倍数
    [m,n,~]=size(img);
    m_=ceil(m/16)*16;   %不足16倍数向上补足
    n_=ceil(n/16)*16;   %不足16倍数向上补足
    for i=m+1:m_
        img(i,:,:)=img(m,:,:);
    end
    for j=n+1:n_
        img(:,j,:)=img(:,n,:);
    end
    result=img;
end