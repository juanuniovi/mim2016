clear; clf;

% prob 24: el de la inductancia solución 'retorcida' de Javier Uria, 2004
%
% Primero supone alpha conocida, y calcula por MC los otros 4 parametros.
% Con lo obtenido en esos 4, calcula alpha por MCs, e iterando...
% ...no se alcanza el óptimo que con MC completos.
%-----------------
datosinduc;
in=1
alpha(in)=1;
A=[n w d D];
A=log(A);
L2=zeros(length(L),1);
for i=1:280,
    norma(in)=(norm((L2./L)-1));
    y=log(L/alpha(in));
    beta(in,:)=inv(A'*A)*A'*y;
    B=(n.^beta(in,1)).*(w.^beta(in,2)).*(d.^beta(in,3)).*(D.^beta(in,4));
    C=B./L;
    in=in+1;
    alpha(in)=inv(C'*C)*C'*ones(length(L),1);
    L2=alpha(in)*B;
    e(in,:)=100*abs(L2-L)./L;
    em(in)=sum(e(in,:))/length(e(in,:));
end