%
% p_masamuelleruido.M
%
%clear
%echo off,hold off;
%whitebg, 
%set(gca,'FontSize',6);

pause off % para no ejecutar las pausas y el script corra entero
echo on
%------------------------------------------
% CONDICIONES: NUESTRO MODELO DEL PROCESO 
% En este caso se trata de un modelo masa-muelle-rozamiento 
% ya descrito 
% PULSE UNA TECLA PARA SEGUIR...
%------------------------------------------
echo off, pause
m=1; J=1; k=1;
A=[-J/m -k/m;1 0];
B=[1/m;0];
C=[0 1];
D=[0];
modelo=ss(A,B,C,D)
% Valores iniciales:
x0=[0 0];
% printsys(A,B,C,D)

echo on
%------------------------------------------
% EL PROCESO "REAL", lo construiremos a partir de modelo matemático,
% variándo sus parámetros un tanto por ciento, al que llamaremos
% "error de modelado".
%------------------------------------------
echo off, pause

errmod=2; % en tanto por ciento de error en los parámetros
mreal=m*(1+(errmod/100)); 
Jreal=J*(1-(errmod/100)); 
kreal=k*(1+(errmod/100));
Ar=[-Jreal/mreal -kreal/mreal;1 0];
Br=[1/mreal;0];
Cr=[0 1];
Dr=[0];
proceso=ss(Ar,Br,Cr,Dr)
% printsys(Ar,Br,Cr,Dr)

echo on
%------------------------------------------
% Como es sistema es de tipo SISO, podemos fácilmente comparar los
% polos y ceros del sistema real con los de nuestro modelo aproximado
%------------------------------------------
echo off, pause

[num,den]=ss2tf(A,B,C,D)
[num_r,den_r]=ss2tf(Ar,Br,Cr,Dr)

echo on
%------------------------------------------
% Por último, construyamos una señal de entrada UU con la que actuaremos
% sobre el sistema real durante los ensayos 
%------------------------------------------
echo off, pause

% Entrada para el analisis: 1a fila escalones,
% 2a fila ruido normal de varianza 0.1 (se usa en estocasticos)
%
dt = 0.01 ; % simulation time step, in seconds
tfinal = 40 ; % simulation time, in seconds
t=0:dt:tfinal; % vector de tiempos para las simulaciones

% Entrada tipo 1, rectangular diseñada a mano (la utilizada en el texto)
% Depende de que tfinal=20 y dt=0.1
UU(1,1:91)=ones(1,91);
UU(1,91:121)=-ones(1,31);
UU(1,121:151)=ones(1,31);
UU(1,151:181)=-ones(1,31);
UU(1,181:201)=ones(1,21);
%%UU(2,1:201)=0.1*randn(1,201); % ruido que utilizaremos mñas tarde
%%UUceros=zeros(1,201);

% Entrada parecida a la anterior, pero válida para cualquier tfinal.
% 
clear UU;
UU(1,:)= t>=0 & t<tfinal/1.5;


% Respuesta de nuestro modelo del proceso ante esta entrada:
x = x0'; y = C*x ; % initial conditions
tvec = 0.0 ; yvec = 0.0 ; i = 1 ; % define vectors for storing outputs
for t=0:dt:tfinal, % loop over time for simulation
    xdot = A*x + B*UU(1,i) ; % plant dynamics
    x = xdot*dt + x ; % euler integrate dynamics
    y = C*x + D*UU(1,i) ; ; % output equation
    yvec(i) = y ; tvec(i) = t ; % store output & time into vectors
    i = i + 1 ; % increment vector index
end ;

% Otra manera de obtener la respuesta:
t=0:dt:tfinal; % tiempo durante el que se harán las simulaciones
[y_A,x_A] = lsim(A,B,C,D,[UU(1,:)],t,x0);

% o en el estilo moderno de  matlab ...
[y_A2,t,x_A2] = lsim(modelo,[UU(1,:)],t,x0);
[y_Ap,t,x_Ap] = lsim(proceso,[UU(1,:)],t,x0);

% La respuesta debería ser parecido si nuestro periodo de discretizacion
% dt es suficientemente pequeño.
figure
plot(t,UU)
xlabel('time (sec)') ; ylabel('y') ;
title('Respuesta del modelo y del proceso real') ;
hold on
plot(t,yvec,'m')
plot(t,y_A,'r')
plot(t,y_Ap,'g')
grid
hold off ;
legend('entrada',  'salida (a mano)', 'salida (lsim)', 'salida del proceso real') ;

%%---- FIN DE p_masamuelleruido.M --------
