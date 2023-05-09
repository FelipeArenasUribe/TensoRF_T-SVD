%% Import Tensor Product Toolbox
%addpath("Tensor-tensor-product-toolbox-master/tproduct toolbox 1.0/")
addpath("Tensor-tensor-product-toolbox-master/tproduct toolbox 2.0 (transform)/")

%% Loas CP_Parameters from TensoRF model
% Load CP_Parameters
load('CP_values_small.mat')

%% Build Volume Density Tensor using CP Vectors
% Initialize Tensor
grid_size = [size(x, 2) size(y, 2) size(z, 2)];
rank_treshold = min(size(x));
A = zeros(grid_size);

% Build Tensor aproximation
f = waitbar(0, 'Starting');

for rank = 1:rank_treshold
    for grid_x = 1:grid_size(1)
        for grid_y = 1:grid_size(2)
            for grid_z = 1:grid_size(3)
                A(grid_x, grid_y, grid_z) = A(grid_x, grid_y, grid_z) + (x(rank, grid_x)*y(rank, grid_y)*z(rank, grid_z));
            end
        end
    end
    waitbar(rank/rank_treshold, f, sprintf('Rebuilding Volume Density Tensor: %d %%', floor(rank/rank_treshold*100)));
    pause(0.1);
end

close(f)

%% perform fast3D DCT and measure time
A_tilda = A(1:88, 1:88,:);

yyX=fast3DDCT(A_tilda);

% Visualize DCT
for slice = (1:grid_size(3))
    t = tiledlayout(1,2);
    
    nexttile
    imagesc(A(:,:,slice))
    colorbar
    title('x slice visualization')

    nexttile
    imagesc(yyX(:,:,slice))
    colorbar
    title('DCT(x) slice visualization')

    disp(['Displaying slice: ',num2str(slice)])
    input('Press enter to continue...')
end

%% Compress tensor using DCT coefficients
