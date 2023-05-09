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

%% Compute T-SVD Decomposition of Volume Density Tensor
% T-SVD Decomposition of A
%[U,S,V] = tsvd(A,'full');

transform.L = @fft; transform.l = grid_size(3); transform.inverseL = @ifft;
[U,S,V] = tsvd(A,transform,'econ');

%% Build Tensor Aproximation using Truncated T-SVD
% cumsum algorithm, sum in 3rd dim.
cum_e = cumsum(diag(sum(S,3)))/sum(diag(sum(S,3)));

% find the 90 percent cut off
trank = find(cum_e>.9,1);

t_U = U(:,1:trank,:);
t_V = V(:,1:trank,:);
t_S = S(1:trank,1:trank,:);

t_A = tprod(tprod(t_U,t_S,transform),tran(t_V,transform),transform);

%% Create Tensorial visualizations

% A plots
figure('Name','Tensor plots','NumberTitle','off');
t_a = tiledlayout(1,3);

nexttile
imagesc(A(:,:,1))
colorbar
title('A slices visualization 0')

nexttile
imagesc(A(:,:,floor(size(A,3)*(3/6))))
colorbar
title('A slices visualization 1/2')

nexttile
imagesc(A(:,:,floor(size(A,3)*(6/6))))
colorbar
title('A slices visualization 1')

% t_A plots
figure('Name','Truncated Tensor plots','NumberTitle','off');
t_t = tiledlayout(1,3);

nexttile
imagesc(t_A(:,:,1))
colorbar
title('Truncated A slices visualization 0')

nexttile
imagesc(t_A(:,:,floor(size(A,3)*(3/6))))
colorbar
title('Truncated A slices visualization 1/2')

nexttile
imagesc(t_A(:,:,floor(size(A,3)*(6/6))))
colorbar
title('Truncated A slices visualization 1')

% U plots
figure('Name','U plots','NumberTitle','off');
t_u = tiledlayout(1,3);

nexttile
test_u = reshape(U(:,floor(size(A,2)*(6/6)/size(A,2)),:), [size(U,1), size(U,3)]);
imagesc(test_u)
colorbar
title('U slices visualization 0')

nexttile
test_u = reshape(U(:,floor(size(A,2)*(3/6)),:), [size(U,1), size(U,3)]);
imagesc(test_u)
colorbar
title('U slices visualization 1/2')

nexttile
test_u = reshape(U(:,floor(size(A,2)*(6/6)),:), [size(U,1), size(U,3)]);
imagesc(test_u)
colorbar
title('U slices visualization 1')

% S plots
figure('Name','S Plots','NumberTitle','off');
t_s = tiledlayout(1,3);

nexttile
imagesc(S(:,:,floor(size(A,3)*(6/6)/size(A,3))))
colorbar
title('S slices visualization 0')

nexttile
imagesc(S(:,:,floor(size(A,3)*(3/6))))
colorbar
title('S slices visualization 1/2')

nexttile
imagesc(S(:,:,floor(size(A,3)*(6/6))))
colorbar
title('S slices visualization 1')

% V plots
figure('Name','V Plots','NumberTitle','off');
t_v = tiledlayout(1,3);
VT = tran(V,transform);

nexttile
test_v = reshape(VT(floor(size(A,1)*(6/6)/size(A,1)),:,:),[575, 412]);
imagesc(test_v)
colorbar
title('V slices visualization 0')

nexttile
test_v = reshape(VT(floor(size(A,1)*(3/6)),:,:),[575, 412]);
imagesc(test_v)
colorbar
title('V slices visualization 1/2')

nexttile
test_v = reshape(VT(floor(size(A,1)*(6/6)),:,:),[575, 412]);
imagesc(test_v)
colorbar
title('V slices visualization 1')

%% Cumulative Energy and Singular Value analysis
tensor_analyze(A)