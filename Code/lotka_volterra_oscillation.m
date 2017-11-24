clear;
close all;

K = 100; % biotop limit
alpha = 0.01; % meeting chance

% reproduction rate
ra = 0.1;
rb = -0.1; % die rate for predator

% effect when meet
la = -0.1; % die
lb = 0.1; % reproduce after the meal

a = [1];
b = [1];

delta_t = .1;
duration = 500;
t = 1:duration/delta_t;
for i = [t(1):t(end-1)]

    delta_a = ra*(1- (a(end)+b(end))/K)*a(end) + la*alpha*a(end)*b(end);
    delta_b = rb*(1- (a(end)+b(end))/K)*b(end) + lb*alpha*a(end)*b(end);
    
    a(end+1) = a(end) + delta_a*delta_t;
    b(end+1) = b(end) + delta_b*delta_t;
    
end

plot(t,a,t,b);
