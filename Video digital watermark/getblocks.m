function b = getblocks(mb)
b=zeros([8,8,6]);
%四个亮度块
b(:,:,1)=mb(1:8,1:8,1);
b(:,:,2)=mb(1:8,9:16,1);
b(:,:,3)=mb(9:16,1:8,1);
b(:,:,4)=mb(9:16,9:16,1);
%两个色彩块
b(:,:,5)=0.25*(mb(1:2:15,1:2:15,2)+mb(1:2:15,2:2:16,2)+...
    mb(2:2:16,1:2:15,2)+mb(2:2:16,2:2:16,2));
b(:,:,6)=0.25*(mb(1:2:15,1:2:15,3)+mb(1:2:15,2:2:16,3)+...
    mb(2:2:16,1:2:15,3)+mb(2:2:16,2:2:16,3));
end

