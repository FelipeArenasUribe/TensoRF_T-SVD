function y=xtildaijl(x,i,j,l,n1,n2,n3)
% this function is for calculation with reorderin.
% n1,n2,n3 are given index buth xtilda change the index how it has to be
N=size(x,1);
y=xtilda(x,n1,n2,n3)+(-1)^l*xtilda(x,n1,n2,n3+N/2)+(-1)^j*xtilda(x,n1,n2+N/2,n3)+...
    (-1)^(j+l)*xtilda(x,n1,n2+N/2,n3+N/2)+(-1)^i*xtilda(x,n1+N/2,n2,n3)+...
    (-1)^(i+l)*xtilda(x,n1+N/2,n2,n3+N/2)+(-1)^(i+j)*xtilda(x,n1+N/2,n2+N/2,n3)+...
    (-1)^(i+j+l)*xtilda(x,n1+N/2,n2+N/2,n3+N/2);