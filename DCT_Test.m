addpath("3dFDCT/")

% define N for time compuming test
N=32;

% generate NxNxN gaussian random input
x=rand(N,N,N);

% perform fast3D DCT and measure time
yyX=fast3DDCT(x);

% Visualize DCT
for slice = (1:N)
    t = tiledlayout(1,2);
    
    nexttile
    imagesc(x(:,:,slice))
    colorbar
    title('x slice visualization')

    nexttile
    imagesc(yyX(:,:,slice))
    colorbar
    title('DCT(x) slice visualization')

    disp(['Displaying slice: ',num2str(slice)])
    input('Press enter to continue...')
end