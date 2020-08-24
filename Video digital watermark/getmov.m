function movdata = getmov(mov,nf)
%函数用于把frame结构数组转化为易操作的4D-uint8(0)数组
    if nf==0 %当函数输入的参数为0时，表示取出视频的全部帧数
        nf=length(mov);
    end
    %对movdata赋初值，构建一个4D的全uint8（0）数组
    %数组的各个维度分别为（高度，宽度，颜色，帧数nf）
    movdata=repmat(uint8(0),[size(mov(1).cdata),nf]);
    %将mov中的前nf帧的数据分别赋给movdata（:,:,:,i）
    for i=1:nf
        movdata(:,:,:,i)=mov(i).cdata;
    end
end
