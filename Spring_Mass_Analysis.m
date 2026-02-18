% Multi Spring Mass Static Equilibrium
% Form stiffness matrix for 5 to 10 mass spring chain and compute displacement under applied loads using linear system solvers.

clc;
clear;
close all;

N = input('Enter number of masses: ');

m = zeros(N,1);
disp('Enter mass values (kg):');

% mass input from user
for i = 1:N
    m(i) = input(['m(', num2str(i), ') = ']);
end

% constants input from user
c = input('Enter damping coefficient (Ns/m): ');
mu = input('Enter coefficient of friction (0 to 1): ');
g = 9.81;
k0 = input('Enter stiffness of LEFT wall spring (N/m): ');

% stiffness input from user
k = zeros(N-1,1);
for i = 1:N-1
    k(i) = input(['k(', num2str(i), ') = ']);
end

kN = input('Enter stiffness of RIGHT wall spring (N/m): ');

F1 = input('Enter load applied on first mass (N): ');

M = diag(m);
C = c * eye(N);
K = zeros(N,N);

% Stiffness matrix of spring system
for i = 1:N
    if i == 1
        K(i,i)   = k0 + k(1);
        K(i,i+1) = -k(1);
    elseif i == N
        K(i,i)   = k(N-1) + kN;
        K(i,i-1) = -k(N-1);
    else
        K(i,i)   = k(i-1) + k(i);
        K(i,i-1) = -k(i-1);
        K(i,i+1) = -k(i);
    end
end

% force matrix
F = zeros(N,1);
F(1) = F1;

% time stamp
dt = 0.01;
max_steps = 2000;
tolerance = 1e-6;

t = zeros(1,max_steps);
x = zeros(N,max_steps);
v = zeros(N,max_steps);
a = zeros(N,max_steps);

for step = 1:max_steps-1
    
    t(step+1) = t(step) + dt;
    
    F_fric = mu * m * g .* sign(v(:,step));
    
    a(:,step) = M \ (F - C*v(:,step) - K*x(:,step) - F_fric);
    
    v(:,step+1) = v(:,step) + dt*a(:,step);
    x(:,step+1) = x(:,step) + dt*v(:,step);
    
    if max(abs(v(:,step+1))) < tolerance && ...
       max(abs(a(:,step))) < tolerance
        
        disp(['System reached steady state at time = ', num2str(t(step+1)), ' seconds']);
        break
    end
end

x = x(:,1:step+1);
t = t(1:step+1);

figure;
plot(t, x', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Displacement (m)');
title('Displacement of Masses vs Time');
grid on;

legendStrings = strings(1,N);
for i = 1:N
    legendStrings(i) = ['Mass ', num2str(i)];
end
legend(legendStrings);

x_final = x(:,end);

disp('Final displacement of masses (m):');
disp(x_final);

spring_ext = zeros(N+1,1);
spring_ext(1) = x_final(1);

for i = 1:N-1
    spring_ext(i+1) = x_final(i+1) - x_final(i);
end

spring_ext(N+1) = -x_final(N);

disp('Final displacement (extension) of springs (m):');
disp(spring_ext);
