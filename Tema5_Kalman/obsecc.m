%
% OBSECC.M: se estudia el efecto sobre diferentes observadores
% de errores de modelado y de diferentes c.i.
% En el primer experimento se comprueba como todos los observadores,
% tanto los lentos como los rapidos (respecto a la planta), corrigen
% las diferentes condiciones iniciales.
% En el segundo se observa que los observadores mas lentos que la planta
% no corrigen errores de modelado.
% Los modelos son deterministas, y los observadores de orden completo.
% El sistema a estudio y los detalles estan en el documento adjunto.
%

echo on
%--------------------------------------------------------------------
% EXPERIMENTO 2: OBSERVADORES EN C.C.
%
% AHORA REPETIMOS EL EXPERIMENTO PARA OBSERVADORES EN CADENA CERRADA,
% Y VEREMOS LA INFLUENCIA DEL ERROR DE MODELADO 
% Veremos que un observador cuyos polos interfieran con los
% del sistema a observar, no es capaz de identificar el estado
% correctamente, mientras que los otros, con polos mas alejados, si.
%--------------------------------------------------------------------
% Experimento:
%
%                            _______
%             ______ 5     1| Proce.|1       3 ______
%         4  |Mpxor.|-------|   1   |---------| Obse.|----2
%       -----|  3   |6      |_______|        2|  2   |----3
%            |______|-------------------------|______|----4
%
%
echo off, pause

 % El polinomio característico p_O recoje las especificaciones 
 % (polos) del observador. Repetiremos la simulacion para 4 observadores 
 % con sus polos cada vez más lejanos. 
 
 SalidaMedida=[1];
 EntradaConocida=[1];
for iii=0:1:3,

        % Las especificaciones de los Polos del Observador varian en 
        % cada iteraccion, siendo cada vez más rapidos (lejanos)  
        p_O(:,iii+1)=[-(iii+.010)/.5 -(iii+.011)/.5]'  % Polos del Observador

        % Sintesis del Observador por asignacion de polos
        K=place(A',C',p_O(:,iii+1))                % Asignacion
        [Ae,Be,Ce,De]=estim(A,B,C,D,K',SalidaMedida,EntradaConocida);        % Observador

        % Construccion del sistema total :

        a1=Ar,b1=Br,c1=Cr,d1=Dr;                % El proceso real
        a2=Ae,b2=Be,c2=Ce,d2=De;                % El observador
        a3=[0],b3=[0]',c3=[0 0]',d3=[1 1]';  % Un multiplexador

        nblocks=3;
        blkbuild;               % Crea el macro-bloque [a,b,c,d]
        Q=[1 5;
           2 6;
           3 1];
        entradas=[4];
        salidas=[2 3 4];
        [AA,BB,CC,DD]=connect(a,b,c,d,Q,entradas,salidas);

        % Respuesta del conjunto completo, con condiciones iniciales
        % del observador [0 0]:
        [y_A,x_A] = lsim(AA,BB,CC,DD,UU(1,:),t,[x0 [0 0]]);

        % Para posteriores estudios, guardamos la evolucion del estado 
        % observado x2, y la del estado real x2
        estados(:,iii+1)=y_A(:,2);
        real(:,iii+1)=x_A(:,1);
end

% EJEMPLOS DE ANALISIS DE RESULTADOS POSTERIORES
% Evolucion del estado observado X2 con los diferentes observadores
%
figure
subplot(311),plot(t,estados(:,1)),axis([0 20 -1.4 1.4]),title('Estimaciones de x2, obs.1'),grid;
subplot(312),plot(t,estados(:,2)),axis([0 20 -1.4 1.4]),title('obs.2'),grid;
subplot(313),plot(t,estados(:,3)),axis([0 20 -1.4 1.4]),title('obs.3'),grid;
% subplot(224),plot(t,estados(:,4)),axis([0 20 -1.4 1.4]),title('obs.4'),grid;

% Diferencia entre el real y el observado con diferentes c.i.
%
figure
subplot(411),plot(t,estados(:,1)-real(:,1)),title('Error de observacion, obs.1'),grid;
subplot(412),plot(t,estados(:,2)-real(:,2)),title('Error, obs.2'),grid;
subplot(413),plot(t,estados(:,3)-real(:,3)),title('Error, obs.3'),grid;
subplot(414),plot(t,estados(:,4)-real(:,4)),title('Error, obs.4'),grid;

%---- FIN DE OBSECC.M ---------
