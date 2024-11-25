%作业说明和要求：
%图像 —— 二维图像，尺寸为32X32个4.0625mmX4.0625mm的像素单元。
%探测器 —— 由32个探测单元组成的一维探测器，探测单元大小等于图像像素大小。
%数据采集—— 探测器绕视野中心旋转60个视角，相邻视角间隔6 °；在探测器前装备具有理想成像特性的平行孔准直器，
%投影获取 -采集得到两组投影数据。一组无噪声，一组包含泊松统计噪声。
%（1）图像重建 ——使用MLEM迭代算法给出重建图像。其中，重建图像初值统一设为全1。
%（2）给出第1,5,40,200次迭代得到的重建图像，以及对应迭代次数时通过当前图像前投影得到的投影估计值（正弦图格式）。
%（3）给出极大似然代价函数值随迭代次数的变化曲线。
%1）proj.mat: 无噪声投影数据，大小是1920X1，其中1920=32X60是投影单元总数。数据排列方式：
% 第1-32个数是第一个采集角度的32个探测单元，第33-64个数是第二个采集角度的32个探测单元，第65-96个数是第三个采集角度的32个探测单元；
%（2）Proj_noisy.mat: 投影数据，大小和数据格式同上，为包含泊松统计噪声数据；
%（3）sysmat.mat: 系统传输矩阵，大小是1024X1920，其中1024=32X32是图像像素个数，1920是投影单元总数，数据排列方式同上。

%满足proj = sysmat*x;
%先把sysmat给导入(1920*1024)
clc
clear

load("sysmat.mat","sysmat");
sysmat = sysmat.';
%再把有/无噪声的投影数据导入(1920*1)
load("proj.mat","proj");
%load("proj_noisy.mat","proj");
loglike=zeros(200,1);
%x(1920*1)设置初始化全为1
f =ones(1024,1);
q=0;
p1=zeros(1920,1);
r1=zeros(1920,1);
r2=zeros(1024,1);
r3=zeros(1024,1);
pic=zeros(32,32);
sine=zeros(32,60);
%MLEM算法
Pstd = proj;    %这个取决于要不要噪声，有噪声就是第23行,无噪声就是第22行；
for k = 1:1:200
   p1=sysmat*f;
   r1=Pstd./p1;
   r2=sysmat.'*r1;
   r3=sum(sysmat);
   f=f.*r2./r3.';
   if k==1||k==5||k==40||k==200
       pic = reshape(f,32,32);
       title_str={"重建图像", num2str(k)};
       figure;
       pcolor(pic);shading interp;colorbar;colormap("jet");title(title_str);
       title_str={"投影正弦图",num2str(k)};
       figure;
       sine = reshape(p1,32,60);
       pcolor(sine);shading interp;colorbar;colormap("jet");title(title_str);
   end
   loglike(k,1)=sum(Pstd.*log10(sysmat*f)-sysmat*f);
end
figure;
plot(loglike);title("代价函数");








