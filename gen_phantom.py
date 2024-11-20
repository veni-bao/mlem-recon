import numpy as np
import random
# 设置图像大小
width, height = 100, 100

# 设置圆的位置和半径
center_x, center_y = 50, 50  # 圆心位置
radius = 20  # 圆的半径

# 创建一个100x100的空数组，所有元素初始化为0.0
image = np.zeros((height, width), dtype=np.float32)

# 填充圆内的像素值为1.0
for y in range(height):
    for x in range(width):
        if (x - center_x)**2 + (y - center_y)**2 <= radius**2:
            image[y, x] = int(2*random.random())

# 将数组以二进制形式保存到.dat文件
with open('phantom_random.dat', 'wb') as f:
    image.tofile(f)
