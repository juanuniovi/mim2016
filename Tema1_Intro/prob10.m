clear all; close all; 

G = [1 .2 .1; .1 2 .1; .3 .1 3] % Gain matrix 
gamma = 3; % minimum SINR 
alpha = 1.2; % safety margin 
sigma = 0.01; % Noise power (same for all receivers) 

% Form the A and b matrices 
A = zeros(3,3); 
for i = 1:3 
    for j = 1:3 
        if (i~=j) 
            A(i,j) = alpha*gamma*G(i,j)/G(i,i); 
        end 
    end 
end 

b = zeros(3,1); 
for i = 1:3 
    b(i) = alpha*gamma*sigma/G(i,i); 
end 

% Simulate 
num_iterations = 20; 
p_i = [.1;.1;.1]; % Initialized to p(0) 
S = [G(1,1)*p_i(1)/(sigma+G(1,2)*p_i(2)+G(1,3)*p_i(3)); 
    G(2,2)*p_i(2)/(sigma+G(2,1)*p_i(1)+G(2,3)*p_i(3));  
    G(3,3)*p_i(3)/(sigma+G(3,1)*p_i(1)+G(3,2)*p_i(2))]; 
    % matrix to store the SINR values versus time (initialize to the 
    % SINR for time 0) 

p = p_i; % matrix to store the powers versus time 

for i = 1:num_iterations 
    p_i = A*p_i+b; 
    p = [p p_i]; % Find the new powers and save 
    SINR_current = [G(1,1)*p_i(1)/(sigma+G(1,2)*p_i(2)+G(1,3)*p_i(3));
                    G(2,2)*p_i(2)/(sigma+G(2,1)*p_i(1)+G(2,3)*p_i(3)); 
                    G(3,3)*p_i(3)/(sigma+G(3,1)*p_i(1)+G(3,2)*p_i(2))]; 
     S = [S SINR_current]; 
 end 
 
 % Plot the results 
 figure(1); 
 temp = 0:num_iterations; 
 subplot(2,1,1); 
 plot(temp,p(1,:));

 plot(temp,p(1,:),'--', temp,p(2,:),'-',temp,p(3,:),'-.'); 
 xlabel('Numero de Iteracion'); ylabel('Potencia de Emision'); 
 title('\gamma = 3, potencias iniciales = [.1;.1;.1]'); 
 legend('Emisor 1', 'Emisor 2', 'Emisor 3',0); grid; 
 
 subplot(2,1,2); plot(temp,S(1,:),'--', temp,S(2,:),'-',temp,S(3,:),'-.'); 
 xlabel('Numero de Iteracion'); ylabel('SINR'); 
 title('\gamma = 3, potencias iniciales = [.1;.1;.1]'); 
 legend('Emisor 1', 'Emisor 2', 'Emisor 3',0); grid; 
