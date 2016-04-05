%Problema de immpulsos cohete por mínimos cuadrados

%Masa del objeto
m=1;

%Vector de posiciones y velocidades---------------------------------------
p0=0;
p1=0;
p2=0;
p3=0;
p4=0;
p5=0;
p6=0;
p7=0;
p8=0;
p9=0;
p10=1;

v0=0;
v1=0;
v2=0;
v3=0;
v4=0;
v5=0;
v6=0;
v7=0;
v8=0;
v9=0;
v10=0;

%y=[p0 p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 v0 v1 v2 v3 v4 v5 v6 v7 v8 v9 v10]';

%Vector y objetivo
y=[p0 p9 p10 v0 v10]';

%Matrices de transformación------------------------------------------------

%Matriz A de posciones
A_p=[1/m 0 0 0 0 0 0 0 0 0 0;
    2/m 1/m 0 0 0 0 0 0 0 0 0; 
    3/m 2/m 1/m 0 0 0 0 0 0 0 0; 
    4/m 3/m 2/m 1/m 0 0 0 0 0 0 0; 
    5/m 4/m 3/m 2/m 1/m 0 0 0 0 0 0; 
    6/m 5/m 4/m 3/m 2/m 1/m 0 0 0 0 0;  
    7/m 6/m 5/m 4/m 3/m 2/m 1/m 0 0 0 0;  
    8/m 7/m 6/m 5/m 4/m 3/m 2/m 1/m 0 0 0;  
    9/m 8/m 7/m 6/m 5/m 4/m 3/m 2/m 1/m 0 0;
    10/m 9/m 8/m 7/m 6/m 5/m 4/m 3/m 2/m 1/m 0;
    11/m 10/m 9/m 8/m 7/m 6/m 5/m 4/m 3/m 2/m 1/m;];

%Matriz A de velocidades
A_v=[1/m 0 0 0 0 0 0 0 0 0 0;
    1/m 1/m 0 0 0 0 0 0 0 0 0; 
    1/m 1/m 1/m 0 0 0 0 0 0 0 0; 
    1/m 1/m 1/m 1/m 0 0 0 0 0 0 0; 
    1/m 1/m 1/m 1/m 1/m 0 0 0 0 0 0; 
    1/m 1/m 1/m 1/m 1/m 1/m 0 0 0 0 0;  
    1/m 1/m 1/m 1/m 1/m 1/m 1/m 0 0 0 0;  
    1/m 1/m 1/m 1/m 1/m 1/m 1/m 1/m 0 0 0;  
    1/m 1/m 1/m 1/m 1/m 1/m 1/m 1/m 1/m 0 0;
    1/m 1/m 1/m 1/m 1/m 1/m 1/m 1/m 1/m 1/m 0;
    1/m 1/m 1/m 1/m 1/m 1/m 1/m 1/m 1/m 1/m 1/m];

%Matriz A objetivo
A=[ 1/m 0 0 0 0 0 0 0 0 0 0;
    9/m 8/m 7/m 6/m 5/m 4/m 3/m 2/m 1/m 0 0; 
    11/m 10/m 9/m 8/m 7/m 6/m 5/m 4/m 3/m 2/m 1/m;
    1/m 0 0 0 0 0 0 0 0 0 0;
    1/m 1/m 1/m 1/m 1/m 1/m 1/m 1/m 1/m 1/m 1/m];

%Vector de fuerzas requerido-----------------------------------------------

%Si la matriz A es DELGADA
%F=(inv((A')*A)*(A'))*y;

%Si la matriz A es GORDA
F=((A')*pinv(A*(A')))*y;

%Ploteo de resultados------------------------------------------------------

%Vector de tiempos para plotear
t=[0 1 2 3 4 5 6 7 8 9 10];

%Vectores para plotear posiciones y velocidades
p=A_p*F;
v=A_v*F;

%Representación de las fuerzas
for i=0:9 
    t1=i:0.01:i+1;
    plot(t1,F(i+2),'*-g','LineWidth',2,'MarkerSize',2);
    grid on
    hold on
end

%Representación de posiciones y velocidades
plot(t, p,'*-r','LineWidth',2,'MarkerSize',5)
hold on
plot(t, v,'*-b','LineWidth',2,'MarkerSize',5)




   


