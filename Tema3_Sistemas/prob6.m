%% PRAC2.M: transformaciones de similaridad
%%

% Parametros del sistema y descripcion E/S:
%
M=0.5;J=0.5;K=0.5; num=[0 0 1/M]; den=[1 J/M K/M];

% Forma 0 en EE: la que da TF2SS de MATLAB (una forma normalizada)
%
[a,b,c,d]=tf2ss(num,den)

% Forma 1 en EE: otra forma normalizada
%
T1=[0 1;1 0];
[a1,b1,c1,d1]=ss2ss(a,b,c,d,inv(T1))

% Forma 2 en EE: la canonica de Jordan
%
[v,w]=eig(a1);
T2=v;
[a2,b2,c2,d2]=ss2ss(a1,b1,c1,d1,inv(T2))

% Forma 3 en EE: la canonica que da CANON de MATLAB
%
[a3,b3,c3,d3,iT3]=canon(a1,b1,c1,d1,'modal')
T3=inv(iT3)

% Obtenemos la forma 3 directamente, usando la matriz de paso
%
[a31,b31,c31,d31]=ss2ss(a1,b1,c1,d1,inv(T3))

% Las formas canonicas estan relacionadas por la matriz de paso T4.
% Podemos pues obtener la forma 2 a partir de la forma 3
%
T4=inv(T3)*T2;
[a21,b21,c21,d21]=ss2ss(a3,b3,c3,d3,inv(T4))

% Forma canonica controlable (FCC)
%
[Acc,Bcc,Ccc,Tcc,Kcc]=ctrbf(a,b,c);    % Asi la da Matlab
T1=[0 1;1 0];
[Ac,Bc,Cc,Dc]=ss2ss(Acc,Bcc,Ccc,[0],inv(T1))   % Asi la vemos en clase
printsys(Ac,Bc,Cc,[0])
Tc=Tcc*T1;
pause
% Forma Canonica observable (FCO)
%
[Aoo,Boo,Coo,Too,Koo]=obsvf(a,b,c); % Asi la da Matlab
T1=[0 1;1 0];
[Ao,Bo,Co,Do]=ss2ss(Aoo,Boo,Coo,[0],inv(T1))   % Asi la vemos en clase
printsys(Ao,Bo,Co,[0])
To=Too*T1;

%%--- FIN DE PRAC2.M ---%%
