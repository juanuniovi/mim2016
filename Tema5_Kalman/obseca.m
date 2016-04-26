%
% OBSECA.M: se estudia el efecto, sobre un observador en Cadena Abierta,
% de errores de modelado y de diferentes c.i.
% En el primer experimento se comprueba como todos los observadores,
% tanto los lentos como los rapidos (respecto de la planta), corrigen
% las diferentes condiciones iniciales.
% En el segundo se observa que los observadores mas lentos que la planta
% no corrigen errores de modelado.
% Los modelos son deterministas, y los observadores de orden completo.
%

echo on
%------------------------------------------------------------------
% EXPERIMENTO 1: OBSERVADOR EN C.A.
% EFECTO DE LAS DIFERENTES Condiciones Iniciales y Errores de
% Modelado en un Observadores de C.A.
%------------------------------------------------------------------
% Experimento:
%
%                        _______
%         ______ 5     1| Proce.| 1      3 ______
%     4  |Mpxor.|-------|   1   |--     --| Obse.|----2
%   -----|  3   |6      |_______|        2|  2   |----3
%        |______|-------------------------|______|----4
%
echo off, pause


% Sintesis del Observador en C.A.
%

K=[0 0];        % observador en cadena abierta, sin realimentacion
% Observador (al estilo antiguo)
SalidaMedida=[1];
EntradaConocida=[1];
[Ae,Be,Ce,De]=estim(A,B,C,D,K',SalidaMedida,EntradaConocida)        
% Observador (estilo moderno)
observador=estim(modelo,K',SalidaMedida,EntradaConocida)        

% Construcci¢n del sistema total a simular: proceso + observador
% Datos que necesita el script de matlab BLKBUILD:
a1=Ar,b1=Br,c1=Cr,d1=Dr;                % El proceso real
a2=Ae,b2=Be,c2=Ce,d2=De;                % El observador
a3=[0],b3=[0]',c3=[0 0]',d3=[1 1]';     % Un multiplexador
nblocks=3;
% BLKBUILD de matlab es una macro que crea el sistema total [a,b,c,d]
blkbuild;               
Q=[1 5;
   2 6];
entradas=[3 4];
salidas=[1 2 3 4];
[AA,BB,CC,DD]=connect(a,b,c,d,Q,entradas,salidas)

% Lo mismo, con la funcion append (al estilo moderno)
multiplex=ss(a3,b3,c3,d3);
sys = append(proceso,observador,multiplex);
completo=connect(sys,Q,entradas,salidas)  

% Respuesta del conjunto completo: los estados son: [x1 x2 x3 x4]
% x1 y x2 son los estados del sistema original
% x3 y x4 son los del observador.
% Debemos escoger las condiciones iniciales del observador,
% que en general no coincidirán con las del proceso x0
%
x0=[0.4 -0.2];
[y_A,x_A] = lsim(AA,BB,CC,DD,[zeros(1,size(UU,2)); UU(1,:)],t,[x0 [0 0]]);

% o en el estilo moderno de  matlab ...
[y_A,t,x_A] = lsim(completo,[zeros(1,size(UU,2)); UU(1,:)],t,[x0 [0 0]]);

% EJEMPLO DE REPRESENTACION DE ALGUNOS RESULTADOS.
% Evolucion del estado observado X2 (velocidad) con este obs. en C.A.
%
subplot(211),plot(t,y_A(:,4)),axis([0 20 -1.4 1.4]),title('x2 estimado por obs. en C.A.'),grid;
% Diferencia entre el estado real y el observado 
subplot(212),plot(t,y_A(:,4)-x_A(:,2)),title('Error de observacion'),grid;

%%---- FIN DE OBSECA.M --------
