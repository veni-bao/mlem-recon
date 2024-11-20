import numpy as np
import matplotlib.pyplot as plt
from tqdm import tqdm 
import math

plt.rcParams['font.sans-serif'] = ['SimHei']  # 使用黑体
plt.rcParams['font.family']='sans-serif'
plt.rcParams['axes.unicode_minus'] = False  # 正确显示负号
    
def recon(sysmatpath = 'PSF2D_100x100x100x120.dat',phantompath = 'phantom.dat', iter = 20):
    # read file
    with open(sysmatpath, 'rb') as f:
        data = np.array(np.fromfile(f, dtype=np.float32))
    data=data.reshape(12000,10000)

    with open(phantompath, 'rb') as f:
        phantom = np.array(np.fromfile(f, dtype=np.float32))
    phantom=phantom.reshape(10000,1)

    # projection
    projection = data @ phantom

    # MLEM 
    y = np.ones((10000,1),dtype=np.float32)
        #log-likelyhood
    log_likelyhood=np.ones(iter+1)
    log_likelyhood[0]=0

    for _ in tqdm(range(iter)):
        proj_y = data @ y
        y = y * ((data.T @ projection) / (data.T @ proj_y)) 
        log_likelyhood[_+1] = np.sum(data @ y) + np.sum(projection * np.log( data @ y)) -np.sum(np.log(math.gamma(projection[0]+1)))

    fig, ax = plt.subplots(1, 3, figsize=(12, 4))
    cax0 = ax[0].imshow(phantom.reshape(100, 100), interpolation='nearest', cmap='viridis')
    ax[0].set_title('原图')
    fig.colorbar(cax0, ax=ax[0])

    cax = ax[1].imshow(y.reshape(100, 100), interpolation='nearest', cmap='viridis')
    ax[1].set_title(str(iter) + '次迭代后的重建结果')
    fig.colorbar(cax, ax=ax[1])

    # 绘制log-likelyhood
    ax[2].plot(log_likelyhood, marker='o')
    ax[2].set_title('迭代进度')
    ax[2].set_xlabel('迭代次数')
    ax[2].set_ylabel('log-likelyhood')
    ax[2].grid(True)

    plt.tight_layout()
    plt.show()
    return

if __name__ == "__main__":
    recon();
