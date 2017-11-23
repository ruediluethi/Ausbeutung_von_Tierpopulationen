clear;
close all;

%delta = .1;
%duration = 600/delta;
%r = 0.06;
%K = 150000;
%pop_0 = 1;

delta = .1;
duration = 12/delta;
r = 2; % chaos...?
K = 100;
pop_0 = 1;

%delta = 0.1;
%duration = 20/delta;
%r = 1;
%K = 100;
%pop_0 = 1;

E = r/2; % max zulässiger Ertrag, damit weiterhin stabil


t = 1:duration;

pop = [pop_0]; % Absolute Anzahl
pop_change = [0]; % Veränderung
pop_yield = [0]; % Möglicher Ertrag

ypop = [pop_0]; % Absolute Population mit Ertragsentnahme
ypop_change = [0];
ypop_yield = [0];

for i = [t(1):t(end-1)]
    pop_change(end+1) = r*(1-(pop(end)/K))*pop(end)*delta;
    pop_yield(end+1) = E*pop(end)*delta;
    pop(end+1) = pop(end) + pop_change(end); % xn + Zuwachs
    
    ypop_change(end+1) = r*(1-ypop(end)/K)*ypop(end)*delta;
    ypop_yield(end+1) = E*ypop(end)*delta;
    ypop(end+1) = ypop(end) + ypop_change(end) - ypop_yield(end); % xn + Zuwachs - Ertrag
end

subplot(2,2,1);
plot(t,pop,t,pop_change/delta);

subplot(2,2,2);
plot(pop(1:end-1),pop(2:end)-pop(1:end-1),pop(1:end-1),pop_yield(1:end-1));

subplot(2,2,3);
plot(t,ypop);

subplot(2,2,4);
plot(t,ypop_change,t,ypop_yield,t,ypop_change-ypop_yield);




