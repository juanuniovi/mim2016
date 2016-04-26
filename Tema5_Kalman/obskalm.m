%
% OBSKALM.M: se estudia el efecto del RUIDO sobre diferentes observadores,
% incluyendo errores de modelado y diferentes c.i. en procesos.
% Similar al script OBSCC.M pero añadiendo la influencia del ruido.
%
% En el primer experimento se comprueba como todos los observadores,
% tanto los lentos como los rapidos (respecto de la planta), corrigen
% las diferentes condiciones iniciales.
% En el segundo se observa que los observadores mas lentos que la planta
% no corrigen errores de modelado.
% Los modelos son deterministas, y los observadores de orden completo.
%

echo on
% Experimento:
%               Primero el proceso con ruido Arr,Brr,Crr,Drr:
%
%                               2|
%             ______             |       ______
%         1  |A,B,C |1           ------ | Suma |
%       -----|  1   |-------------------|  2   |----2
%            |______|            3      |______|
%
%
%               luego todo junto:
%
%
%                        2-----|
%                            __|____
%             ______ 5   1  | Proce.|1       4 ______
%         5  |Mpxor.|-------| ruido |---------| Obse.|----2
%       -----|  3   |6      |_______|        3|  2   |----3
%            |______|-------------------------|______|----4
%

% Primero "ampliamos" el modelo del proceso real con ruido de salida
% y construimos un nuevo "proceso real ruidoso rr"
%
echo off, pause

a1=Ar,b1=Br,c1=Cr,d1=Dr;                  % El proceso original
a2=[1];b2=[0 0];c2=[0];d2=[1 1];          % Un sumador
nblocks=2;
blkbuild;               % Crea el macro-bloque [a,b,c,d]
Q=[3 1];
entradas=[1 2];
salidas=[2];
[Arr,Brr,Crr,Drr]=connect(a,b,c,d,Q,entradas,salidas);

% Ahora veamos que tal responden 4 diferentes observadores, 
% sucesivamente mas rapidos. Los construimos por asignacion de polos, 
% cada uno mas alejados del eje real (mas rapido) que el anterior,
% como hicimos en el script OBSCC
%
% Las entradas al observador seran:
%
EntradaConocida=[1];   % Las Entradas al proceso conocidas
SalidaMedida=[1];     % y las salidas del proceso medibles

% Contruimos una entrada al proceso que esté contaminada con RUIDO
% DE ENTRADA, p.e. un ruido de media cero y varianza 0.1
%  (nota : al trasponer, pasa a ser la 1a columna !OJO!)
%
UU2=[UU(1,:); 0.1*randn(1,size(t,1))]

% Respuesta del proceso ante tal entrada ruidosa
[y_A,x_A] = lsim(Arr,Brr,Crr,Drr,UU2(1:2,:),t);
figure
subplot(311),plot(UU'),axis([0 200 -2 2]),grid,title('Entrada al proceso (var=.1)')
subplot(312),plot(y_A),axis([0 200 -3 3]),grid,title('Salida del proceso')
subplot(313),plot(x_A),axis([0 200 -1.4 1.4]),grid,title('Estados del proceso')

for iii=0:1:3,  % Probaremos 4 diferentes polos del observador

        p_O(:,iii+1)=[-(iii+.010)/4 -(iii+.011)/4]' % Polos del Observador

        % Sintesis del Observador por asignacion de polos
        K=place(A',C',p_O(:,iii+1))               % Asignacion
        [Ae,Be,Ce,De]=estim(A,B,C,D,K',SalidaMedida,EntradaConocida);        % Observador

        % Construccion del sistema total para la simulacion :
        a1=Arr,b1=Brr,c1=Crr,d1=Drr;                % El proceso
        a2=Ae,b2=Be,c2=Ce,d2=De;                    % El observador
        a3=[0],b3=[0]',c3=[0 0]',d3=[1 1]';  		% El multiplexador

        nblocks=3;
        blkbuild;               % Crea el macro-bloque [a,b,c,d]
        Q=[1 5 ;
           3 6 ;
           4 1 ];
        entradas=[5 2];
        salidas=[2 3 4];
        [AA,BB,CC,DD]=connect(a,b,c,d,Q,entradas,salidas);

        % Respuesta del conjunto completo:
        [y_A,x_A] = lsim(AA,BB,CC,DD,UU2(1:2,:)',t,[x0 [0 0]]);
        % Para posteriores estudios, guardamos la evolucion del estado 
        % observado x2, y la del estado real x2
        estados(:,iii+1)=y_A(:,2);
        real(:,iii+1)=x_A(:,1);
end

% Mapas de polos y ceros de los 4 observadores
%
figure
subplot(221),pzmap([1],poly(p_O(:,1))),title('Polos obs.1'),grid;
subplot(222),pzmap([1],poly(p_O(:,2))),title('Polos obs.2'),grid;
subplot(223),pzmap([1],poly(p_O(:,3))),title('Polos obs.3'),grid;
subplot(224),pzmap([1],poly(p_O(:,4))),title('Polos obs.4'),grid;

% Evolucion del estado observado X2 con los diferentes observadores
%
figure
subplot(311),plot(t,estados(:,1)),axis([0 20 -1.4 1.4]),title('Estimaciones de x2, obs.1'),grid;
subplot(312),plot(t,estados(:,2)),axis([0 20 -1.4 1.4]),title('x2, obs.2'),grid;
subplot(313),plot(t,estados(:,3)),axis([0 20 -1.4 1.4]),title('x2, obs.3'),grid;
%subplot(414),plot(t,estados(:,4)),axis([0 20 -1.4 1.4]),title('x2, obs.4'),grid;

% Diferencia entre el real y el observado con las mismas c.i.
%
figure
subplot(411),plot(t,estados(:,1)-real(:,1)),title('Errores de observacion, obs.1'),grid;
subplot(412),plot(t,estados(:,2)-real(:,2)),title('Errores, obs.2'),grid;
subplot(413),plot(t,estados(:,3)-real(:,3)),title('Errores, obs.3'),grid;
subplot(414),plot(t,estados(:,4)-real(:,4)),title('Errores, obs.4'),grid;

% Medias y varianzas de los errores de observacion
for i=1:4,
       comp(i,1)=mean(estados(:,i)-real(:,i));
       comp(i,2)= cov(estados(:,i)-real(:,i));
end

echo on
%
% Medias y varianzas del error de estimación en los 4 algoritmos:
%
echo off
comp

%%--- FIN DE OBSKALM.M ----%%
