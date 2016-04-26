%
% OBSKALM2.M: gráfica que relaciona el observador optimo con la varianza
% del error de observacion (el optimo es aquel cuyo error de observacion
% es minimo).
%
% Continuacion del script OBSKALM.M
%

% Utilizaremos el proceso Arr,Brr,Crr,Drr con ruidi de salida que se 
% obtuvo en el script OBSKALM.M


for kkk=0:1:16,
    for iii=0:1:3,  % Probaremos 4 diferentes polos

        p_O(:,iii+1)=[-(iii+1.010)/((iii+1)*((kkk+1)*.2)) -(iii+1.011)/((iii+1)*((kkk+1)*.2))]' ;      
        % Polos del Observador

        % Sintesis del Observador por asignacion de polos
        K=place(A',C',p_O(:,iii+1));                    % Asignaci¢n
        [Ae,Be,Ce,De]=estim(A,B,C,D,K',SalidaMedida,EntradaConocida);
        % Observador

        % Construccion del sistema total :
        a1=Arr;b1=Brr;c1=Crr;d1=Drr;                % El proceso ruidoso
        a2=Ae;b2=Be;c2=Ce;d2=De;                    % El observador
        a3=[0];b3=[0]';c3=[0 0]';d3=[1 1]';  		% Un multiplexador

        nblocks=3;
        blkbuild;               % Crea el macro-bloque [a,b,c,d]
        Q=[1 5;
           3 6;
           4 1];
        entradas=[5 2];
        salidas=[2 3 4];
        [AA,BB,CC,DD]=connect(a,b,c,d,Q,entradas,salidas);

        % Respuesta del conjunto completo:
        [y_A,x_A] = lsim(AA,BB,CC,DD,UU(1:2,:)',t,[x0 [0 0]]);
        
        % Para posteriores estudios, guardamos la evolucion del estado 
        % observado x2, y la del estado real x2
        estados(:,iii+1)=y_A(:,2);
        real(:,iii+1)=x_A(:,1);
        
        % ... y guardamos los polos y el error de covarianza de cada
        % estimador para determinar gráficamente cual es el optimo.
        pintay(((kkk*4)+(iii+1)),1)=cov((estados(1:201,iii+1)-real(1:201,iii+1)));
        pintax(((kkk*4)+(iii+1)),1)=p_O(1,iii+1);
    end
end

figure
subplot(212),plot(pintay),grid,title('varianzas')
subplot(211),plot(pintax),grid,title('polos')

%%--- FIN DE OBSKALM2.M 
