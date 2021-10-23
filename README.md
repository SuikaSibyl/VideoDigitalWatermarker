# Video digital watermark

**（1）** **选题**

视频的数字水印嵌入与视频的类mpeg2标准压缩（用于作为攻击水印的手段）。

 

**（2）** **工作简介，即要做什么事情**

通过对视频中随机选取的帧做频域高频部分的改变而嵌入二进制数字水印。用psnr与nc两种手段检测其透明性。分别通过椒盐噪声、高斯噪声、中值滤波、小范围剪切、类似mpeg标准视频压缩等五种手段进行水印攻击。提取水印，并检测该算法鲁棒性。

工作部分除了组织各个函数与脚本以完成流程外，主要包括：实现了视频水印嵌入、视频水印读取、剪切攻击、视频类mpeg2压缩、nc比较绘图函数、psnr比较绘图函数、双视频并行播放函数、运动矢量绘制函数等。最后做了一个GUI界面方便操作测试。

 

**（3）** **开发环境及系统运行要求**

Windows10系统，matlab软件R2018b。



## 2. Technical Details

**（1）** **工程实践当中所用到的理论知识阐述**

l **抽象理论知识**

Ø **鲁棒性（Robustness）** 

指不因图像文件的某种改动而导致隐藏信息丢失的能力。这里所谓"改动"包括图像或者视频传输过程中被恶意破坏。 

Ø **透明性（Invisibility）** 

利用人类视觉系统或人类听觉系统属性，经过一系列隐藏处理，使目标数据没有明显的降质现象 ，而隐藏的数据却可以后期通过技术手段还原。 

Ø **峰值信噪比** 

峰值信噪比(经常缩写为PSNR)是一个表示信号最大可能功率和影响它的表示精度的破坏性噪声功率的比值的工程术语。由于许多信号都有非常宽的动态范围，峰值信噪比常用对数分贝单位来表示。其计算方法如下：

![img](https://github.com/SuikaSibyl/VideoDigitalWatermarker/blob/master/images/clip_image002.jpg)

Ø **归一化互相关系数** 

归一化互相关系数(NC)是度量两幅图像相似度的一个参数，一般来说，NC的值越接近1，两幅图像越相似。

![img](https://github.com/SuikaSibyl/VideoDigitalWatermarker/blob/master/images/clip_image004.jpg)

 

**视频压缩部分**

**（2）** **具体的算法，请用文字、示意图或者是伪代码等形式进行描述（不要贴大段的代码）**

l **总流程**

通过对视频中随机选取的帧做频域高频部分的改变而嵌入二进制数字水印。用psnr与nc两种手段检测其透明性。分别通过椒盐噪声、高斯噪声、中值滤波、小范围剪切、类似mpeg标准视频压缩等五种手段进行水印攻击。提取水印，并检测该算法鲁棒性。

![img](https://github.com/SuikaSibyl/VideoDigitalWatermarker/blob/master/images/clip_image006.jpg)

l **水印嵌入**

首先对水印信息进行随即置换，然后从视频中随机取一些帧作为嵌入的载体，并且将选取视频帧使用到的随机序列作为密钥，在水印提取端作为选择视频帧的依据。

对一个视频序列，假设其亮度分量为fl，则对fl进行分块的二维4x4DCT变换，提取变换后所有的DC系数并排列成一维数组，再对该数组进行分组的一维4*1DCT变换，然后按每个4*1组中第3、4个系数的绝对值之和进行升序排列，根据水印长度自适应选取第3.4个系数绝对值之和较小的组进行水印嵌入。若水印长度为2500则选取前2500个小组。

同时，为了方便水印的提取，对第3、4个系数的绝对值之和设置空挡。如果第2501组第3、4个系数绝对值之和为20，则对后面的所有组别中第三四个系数小于30（20+10）的组进行调整，使得该组底3、4个系数绝对值全部为30，即是说设置水印组和非水印组之间的空挡为10，这个值是动态的，它的大小影响水印算法的鲁棒性。

先设置空挡，再对满足条件的组的第3、4个系数进行调整嵌入水印信息，规则如下：如果当前水印信息为1,则在尽量保持该组中第3、4个系数绝对值的情况下使得第三个系数比第四个系数大const。如果当前的水印信息为0，则使得第三个系数比第四个系数小const。其中const也是动态自适应的，如果第3、4个系数的绝对值之和很小，为了减小对视频质量的影响，选取的const也应该小。之后，进行一系列还原，重新变为视频。

 

![img](https://github.com/SuikaSibyl/VideoDigitalWatermarker/blob/master/images/clip_image008.jpg)


（主干流程）

![img](https://github.com/SuikaSibyl/VideoDigitalWatermarker/blob/master/images/clip_image010.jpg)

（数据嵌入）

 

l **水印读取**

由于保存了水印置乱信息与随机选帧信息，因而从原视频与原水印中复原出嵌入水印时的随机效果。此后，dct等流程与嵌入类似，当到达4*n状态时，比较第3，4交流系数的绝对值之和，取出前2500项作为读取图像所用的目标。一次检测这2500项，其中系数3-4为正数的系数判为信息1，反之则为0，复原出置乱水印，并通过置乱信息还原出原始水印。

![img](https://github.com/SuikaSibyl/VideoDigitalWatermarker/blob/master/images/clip_image012.jpg)

（主干流程）

![img](https://github.com/SuikaSibyl/VideoDigitalWatermarker/blob/master/images/clip_image014.jpg)

（数据读取）

 

l **视频压缩**

组织视频为IPPPP的顺序。

当输入I帧时，信号直接经过DCT按照图片压缩方式压缩。经过颜色下采样，分块，DCT变换，量化，zigzag展开。若当前编码帧是P，则需要将视频信号经过运动估计以及运动补偿，这里运动估计采用了3层的对数法搜索。保存其运动矢量信息，把矩阵作为残差值，再依据图片压缩形式处理。这里由于用于进行水印攻击，省略了熵编码输出的环节，本质上还是很好的还原了视频压缩的流程。

![img](https://github.com/SuikaSibyl/VideoDigitalWatermarker/blob/master/images/clip_image016.jpg)

（主干流程）

 

![img](https://github.com/SuikaSibyl/VideoDigitalWatermarker/blob/master/images/clip_image018.jpg)

（前置流程）

 

![img](https://github.com/SuikaSibyl/VideoDigitalWatermarker/blob/master/images/clip_image020.jpg)

（运动补偿）

 

l **其它实现**

剪切攻击函数：另某一方块内数据置为0；

噪声与滤波函数：使用系统自带函数；

nc与psnr绘图函数：依照公式编写；

视频拼接函数：通过将每帧矩阵拼接实现；

运动矢量绘制函数：利用反复调用系统函数quiver（）；

 

**（3）** **程序开发中重要的技术细节**

l **用到的**

Quiver：矢量绘制

medfilt2：中值滤波攻击

Imnoise：生成椒盐或高斯噪声

Set：用于gui中改变参数

l **编写的**

Crap：剪切攻击

Dct2：专门用于实现8*8dct加速运算

Encmov：压缩编码视频

Enframe：对每一帧编码

Enmacroblock：对每一宏块编码

Getmotionvec：获取运动矢量

Decmpeg：还原压缩编码的视频

Deframe：对每一帧解码

Decmacroblick：还原宏块中编码

Putblocks：把块还原为宏块

Playlast：并行播放两段视频（实际时合成一段播放）

Quiverplot：绘制运动矢量图

##  

##  

 

 

## 3. Experiment Results

**操作说明**

考虑到各部分运行时间可能较长，采用了分脚本运行的模式，但操作过于繁复，合并起来又有输出多、速度慢的弊端，因而采用GUI。

 

请从上至下依次运行“视屏载入”，先选择“加载”，可“播放原视频”

然后选择嵌入水印，其后可选择后四个按钮得到结果。

此后，在接下来的五个模块中可任意选一个模块运行。

 

注意：水印读取后会输出所有水印信息，可使用“关闭所有窗口”关闭他们。

 

**运行结果**

![img](https://github.com/SuikaSibyl/VideoDigitalWatermarker/blob/master/images/clip_image024.jpg)

（嵌入水印前后视觉差异较小）

![nc result1](https://github.com/SuikaSibyl/VideoDigitalWatermarker/blob/master/images/clip_image026.jpg)

（嵌入水印前后nc值基本接近于1，代表基本没有改变）

![PSNR](https://github.com/SuikaSibyl/VideoDigitalWatermarker/blob/master/images/clip_image028.jpg)

（嵌入水印前后psnr值较高，代表透明性强）

![img](https://github.com/SuikaSibyl/VideoDigitalWatermarker/blob/master/images/clip_image030.jpg)

 

（加入椒盐噪声后，大多数的帧还原出来的水印仍可识别 ）

 

 

![img](https://github.com/SuikaSibyl/VideoDigitalWatermarker/blob/master/images/clip_image032.jpg)

 

（加入高斯噪声后，大多数的帧还原出来的水印仍可识别 ）

 

![img](https://github.com/SuikaSibyl/VideoDigitalWatermarker/blob/master/images/clip_image034.jpg)

 

（中值滤波后，大多数的帧还原出来的水印仍可识别 ）

 

![img](https://github.com/SuikaSibyl/VideoDigitalWatermarker/blob/master/images/clip_image036.jpg)

（剪切攻击后，大多数的帧还原出来的水印仍可识别 ）

 

![img](https://github.com/SuikaSibyl/VideoDigitalWatermarker/blob/master/images/clip_image038.jpg)

（压缩攻击后，大多数的帧还原出来的水印仍可识别）

![img](https://github.com/SuikaSibyl/VideoDigitalWatermarker/blob/master/images/clip_image040.jpg)

（视频压缩后，视觉上变化不大）

![img](https://github.com/SuikaSibyl/VideoDigitalWatermarker/blob/master/images/clip_image041.jpg)

（运动矢量呈现）

![img](https://github.com/SuikaSibyl/VideoDigitalWatermarker/blob/master/images/clip_image042.jpg)

（压缩后nc系数仍接近于1）

![img](https://github.com/SuikaSibyl/VideoDigitalWatermarker/blob/master/images/clip_image044.jpg)

（压缩后psnr系数基本维持再较高水平）

 

**总结和说明**

水印嵌入读出、各类水印攻击函数、视频压缩均基本顺利实现。

该种水印算法具有较好的透明性和一定的鲁棒性。在各种攻击的强度较低的时候，仍然能够较好的还原出水印的大概面貌。但是当强度提升（噪声生成系数放大，剪切面积加大，压缩时量化矩阵更加粗糙），结果就不太理想了。

此外在实现过程中发现两个比较有意思的问题。

其一，如果剪切改变了帧的长宽，或者对内部进行了位移，即便是很小的改变也会直接导致水印无法读取。可见鲁棒性并不完善。

其二，在插入水印时可能引发一种bug，即当采用较为简单的平面动画作为视频源，或者在特殊的表现手法中，特定几帧内，dct后得到的AC系数大量为0（譬如有的电影通过纯黑色转场等）。由于在进行拉开差距时，所做的措施是将大于分割值（分割值在例子中是2501个绝对值）的所以绝对值加大，但是如果有超过2500个0，例如假若0-4000位均为0，那么前4000为均不会被加大绝对值。然而前2500位由于经过了加减操作绝对值已经不为0。因而在经过各种dct前后的类型强制转换后重新生成的系数中，很大概率是2501-4000位代替正确的0-2500位中的一些算作水印图像，这就直接导致了即便没有任何攻击也可能不攻自破。后来，我做了一些微小的调整，对于后面所有的系数都进行了扩张，这样虽然损失了图像质量，但也较为有效的解决了这一问题。

不过总之该种算法距离真正实用还差的很远。

## References:

[1]  http://users.cs.cf.ac.uk/Dave.Marshall/Multimedia/Lecture_Examples/Compression/mpegproj/

[2]  吴柯.一种基于DCT系数的数字视频水印方法

[3]  杨东.数字水印的攻击方法及评价
