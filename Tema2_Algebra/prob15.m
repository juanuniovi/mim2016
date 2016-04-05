% Problema de tomografia
datostom
A=zeros(N,n_pixels^2);
for i=1:N
    L=interseccionpixelinea(lines_d(i),lines_theta(i),n_pixels);
    l=reshape(L,n_pixels^2,1);
    A(i,:)=l';
end

x_ls=A\y;
X_ls=reshape(x_ls,n_pixels,n_pixels);
figure(1) 
colormap gray 
imagesc(X_ls) 
axis image

