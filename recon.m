% 这是基于matlab的MLEM重建算法实践     
% 读取文件
fid = fopen('PSF2D_100x100x100x120.dat','rb');
data = fread(fid, 'float32');
data = reshape(data, [10000, 12000])';

fidp = fopen('phantom.dat', 'rb');
phantom = fread(fidp,'float32');
phantom = reshape(phantom, [10000, 1]);

% 投影
projection = data * phantom;

% MLEM
y = ones(10000, 1);
iter = 20;

log_likelyhood = ones(iter + 1, 1);
log_likelyhood(1) = iter;

for idx = 1:iter
    proj_y = data * y;
    y = y .* ((data' * projection) ./ (data' * proj_y));
    lamb = data * y;
    log_likelyhood(idx + 1) = sum(lamb) + sum(projection .* log(lamb)) - sum(log(gamma(projection + 1)));
end

figure;

subplot(1, 3, 1);
imagesc(reshape(phantom,[100,100]));
colorbar;
title('Initial phantom');

subplot(1, 3, 2); 
imagesc(reshape(y,[100,100]));
colorbar;
title(['reconstructed image after ' num2str(iter) ' iterations']);

subplot(1,3,3);
u= linspace(0,iter,iter);
plot(u,log_likelyhood(1:iter),'-*b');

set(gcf, 'Position', [100 200 1800 400]); 