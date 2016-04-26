%
% probrealimentaestados.M: realimentacion de estados por asignacion de polos.
%

pause off % para no ejecutar las pausas y el script corra entero
echo on
%------------------------------------------
% CONDICIONES: NUESTRO MODELO DEL PROCESO 
% Inicilización de un modelo masa-muelle-rozamiento  
% PULSE UNA TECLA PARA SEGUIR...
%------------------------------------------
echo off, pause
m=1; J=1; k=1;
A=[-J/m -k/m;1 0]; B=[1/m;0];
C=[0 1]; D=[0];
modelo=ss(A,B,C,D)
% Valores iniciales:
x0=[0 0];
% printsys(A,B,C,D)


% EL PROCESO "REAL", tiene "error de modelado".
errmod=2; % en tanto por ciento de error en los parámetros
mreal=m*(1+(errmod/100)); 
Jreal=J*(1-(errmod/100)); 
kreal=k*(1+(errmod/100));
Ar=[-Jreal/mreal -kreal/mreal;1 0];
Br=[1/mreal;0]; Cr=[0 1]; Dr=[0];
proceso=ss(Ar,Br,Cr,Dr)
% printsys(Ar,Br,Cr,Dr)

% Una señal de entrada UU con la que actuaremos
% Entrada para el analisis: 1a fila escalones,
% 2a fila ruido normal de varianza 0.1 
%
dt = 0.01 ; % simulation time step, in seconds
tfinal = 40 ; % simulation time, in seconds
t=0:dt:tfinal; % vector de tiempos para las simulaciones

% Entrada tipo 1, rectangular diseñada a mano
% Depende de que tfinal=20 y dt=0.1
UU(1,1:91)=ones(1,91);
UU(1,91:121)=-ones(1,31);
UU(1,121:151)=ones(1,31);
UU(1,151:181)=-ones(1,31);
UU(1,181:201)=ones(1,21);
%%UU(2,1:201)=0.1*randn(1,201); 
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


%------------------------------------------
% OBSERVADORES:  
% Probaremos varios diferentes polos para el sistema realimentado
% PULSE UNA TECLA PARA SEGUIR...
%------------------------------------------

for iii=1:1:3,  
    
    p_O(:,iii+1)=[-(iii+.010)/1 -(iii+.011)/1]' 
    % Polos del sistema realimentado

    % Sintesis de la realimentacion por asignacion de polos
    K=acker(A,B,p_O(:,iii+1))               % Asignacion
        
    % simulacion del sistema de realimentacion diseñado ideal:
    [y_A,x_A] = lsim(A-B*K,B,C-D*K,D,UU(1,:)',t,[x0]);
        
    % simulacion del proceso real realimentado con ese diseño:
    [y_Ar,x_Ar] = lsim(Ar-Br*K,Br,Cr-Dr*K,Dr,UU(1,:)',t,[x0]);
        
    % Para posteriores estudios, guardamos la evolucion de 
    % alguno de los estados y/o salidas obtenidos 
    unasalida(:,iii+1)=y_A(:,1);
    unasalidareal(:,iii+1)=y_Ar(:,1);
    unestado(:,iii+1)=x_A(:,2);
               
    % simulacion alternativa
    % esta vez la hacemos nosotros mismo sin necesidad de la funcion 
    % lsim. La aproximacion es buena para una discretizacion lo
    % suficientemente pequeña.
    x = x0'; y = C*x ; % initial conditions
    tvec = 0.0 ; yvec = 0.0 ; i = 1 ; % define vectors for storing outputs
    for tt=0:dt:tfinal, % loop over time for simulation
        u(i) = UU(1,i)-K*x ;
        xdot = A*x + B*u(i) ; % plant dynamics
        x = xdot*dt + x ; % euler integrate dynamics
        y = C*x + D*u(i) ; % output equation
        yvec(i) = y ; tvec(i) = tt ; % store output & time into vectors
        i = i + 1 ; % increment vector index
    end ;
        
    % Para posteriores estudios, guardamos la evolucion de 
    % alguno de los estados y/o salidas obtenidos 
    unasalida2(:,iii+1)=y_A(:,1);
    unestado2(:,iii+1)=x_A(:,2);
end

% EJEMPLOS DE ANALISIS DE RESULTADOS POSTERIORES
% Evolucion del estado con los diferentes reguladores
%
figure
plot(t,UU)
xlabel('time (sec)') ; ylabel('y') ;
title('Respuesta del modelo y del proceso real con realimentaciones') ;
hold on
plot(t,unasalida,'r-.')
plot(t,unasalidareal,'g-.')
grid
hold off ;
legend('entrada', 'salida diseñada', 'salida obtenida') ;
%%---- FIN DEL SCRIPT --------

