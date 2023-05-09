addpath("Tensor-tensor-product-toolbox\tproduct toolbox 2.0 (transform)\");
​
% creating a 2D matrix cantaining all the z values 
%grid_sz = [-10,10];
%[X,Y] = meshgrid(grid_sz(1):.1:grid_sz(2));
%Z = .5*sin(X) + .5*sin(Y);
​
%mesh(X,Y,Z);
​
%n1 = size(X,1);
%n2 = size(Y,1);
%n3 = 1;
​
% Load image into MATLAB
img = imread('quakka.jpeg');
​
%imshow(img);
​
% Get image dimensions
[rows,cols,channels] = size(img);
​
% Create 3D matrix to hold image data
img_3d = zeros(rows,cols,channels);
​
% Fill 3D matrix with image data
for i = 1:rows
    for j = 1:cols
        for k = 1:channels
            img_3d(i,j,k) = img(i,j,k);
        end
    end
end
​
transform.L = @fft; transform.l = channels; transform.inverseL = @ifft;
​
[U,S,V] = tsvd(img_3d,transform,'skinny');
​
US = tprod(U,S,transform);
USV1 = tprod(US,tran(V,transform),transform);
​
subplot(2, 2, 1);
imshow(img);
title('Original');
subplot(2, 2, 2);
imshow(USV1);
title('Skinny');
%subplot(2, 2, 3);
%imshow(img3);
%title('Image 3');
​
imshow(uint8(USV1));