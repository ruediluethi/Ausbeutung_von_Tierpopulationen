clear;
close all;

delta_t = .1;

duration = 600;
r = 0.06;
K = 150000;
pop_0 = 1;

%duration = 20;
%r = 1;
%K = 100;
%pop_0 = 1;

E = r/2; % max zulässiger Ertrag, damit weiterhin stabil

duration = duration/delta_t;
t = 1:duration;

pop = [pop_0]; % Absolute Anzahl
pop_change = [0]; % Veränderung
pop_yield = [0]; % Möglicher Ertrag

ypop = [pop_0]; % Absolute Population mit Ertragsentnahme
ypop_change = [0];
ypop_yield = [0];

for i = [t(1):t(end-1)]
    pop_change(end+1) = r*(1-(pop(end)/K))*pop(end) *delta_t;
    pop_yield(end+1) = E*pop(end) *delta_t;
    pop(end+1) = pop(end) + pop_change(end); % xn + Zuwachs
    
    ypop_change(end+1) = r*(1-ypop(end)/K)*ypop(end) *delta_t;
    ypop_yield(end+1) = E*ypop(end) *delta_t;
    ypop(end+1) = ypop(end) + ypop_change(end) - ypop_yield(end); % xn + Zuwachs - Ertrag
end

subplot(2,2,1);
plot(t*delta_t,pop,t*delta_t,pop_change/delta_t);
axis([ 0 duration*delta_t 0 K ]);
title('Entwicklung der Population ohne äussere Einflüsse');
legend('Population','Zuwachs');
xlabel('Zeit');
ylabel('Anzahl Tiere');

% calc max population
min_distance = inf;
max_pop = 0;
max_yield = 0;
delta_pop_yield = [];
for i = [1:length(pop)-1]
    a = pop(i+1) - pop(i);
    b = pop_yield(i);
    delta_pop_yield(end+1) = abs(a-b);
    if (pop(i) > K*0.1 && delta_pop_yield(end) < min_distance)
        min_distance = delta_pop_yield(end);
        max_pop = pop(i);
        max_yield = pop_yield(i);
    end
end

subplot(2,2,2);
plot(pop(1:end-1),pop(2:end)-pop(1:end-1),pop(1:end-1),pop_yield(1:end-1),pop(1:end-1),delta_pop_yield,max_pop,max_yield,'ok');
title('Möglicher Ertrag aus der Population');
legend('Zuwachs','Ertrag','Differenz Ertrag Zuwachs',['Max Ertrag'] );
legend('Location','northwest');
xlabel('xn');
ylabel('xn+1');

subplot(2,2,3);
plot(t*delta_t,ypop,[1,duration],[max_pop,max_pop],'k');
axis([ 0 duration*delta_t 0 K ]);
title(['Entwicklung der Population mit Fangintensität r/',num2str(1/(E/r))]);
legend('Population',['Max: ',num2str(round(max_pop))]);
legend('Location','northwest');
xlabel('Zeit');
ylabel('Anzahl Tiere');

subplot(2,2,4);
plot(t*delta_t,ypop_change,t*delta_t,ypop_yield,t*delta_t,ypop_change-ypop_yield,[1,duration],[max_yield,max_yield],'k');
axis([ 0 duration*delta_t 0 K ]);
axis 'auto y';
title('Zuwachs und Ertrag im Vergleich');
legend('Zuwachs','Ertrag','Differenz Ertrag Zuwachs',['Max Ertrag: ',num2str(round(max_yield))]);
legend('Location','northwest');
xlabel('Zeit');
ylabel('Anzahl Tiere');



