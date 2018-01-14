clear;
close all;

delta_t = .1;

% Blauwal data
duration = 600;
r = 0.06; % Reproduktionsrate
K = 150000;

% Test data
%duration = 20;
%r = 1;
%K = 100;

pop_0 = 1;

E1 = r/2; % Fangrate: max zulässiger Ertrag, damit weiterhin stabil
E2 = r/3;

duration = duration/delta_t;
t = 1:duration;

pop = [pop_0]; % Absolute Anzahl
pop_change = [0]; % Veränderung
pop_yield1 = [0]; % Möglicher Ertrag für E1
pop_yield2 = [0]; % Möglicher Ertrag für E2

ypop1 = [pop_0]; % Absolute Population mit Ertragsentnahme
ypop2 = [pop_0]; % Absolute Population mit Ertragsentnahme
ypop_change = [0];
ypop_yield1 = [0];
ypop_yield2 = [0];

for i = [t(1):t(end-1)]
    pop_change(end+1) = r*(1-(pop(end)/K))*pop(end);
    pop_yield1(end+1) = E1*pop(end);
    pop_yield2(end+1) = E2*pop(end);
    pop(end+1) = pop(end) + pop_change(end)*delta_t; % xn + Zuwachs
    
    ypop_change(end+1) = r*(1-ypop1(end)/K)*ypop1(end);
    ypop_yield1(end+1) = E1*ypop1(end);
    ypop_yield2(end+1) = E2*ypop1(end);
    ypop1(end+1) = ypop1(end) + (ypop_change(end) - ypop_yield1(end))*delta_t; % xn + Zuwachs - Ertrag
    ypop2(end+1) = ypop2(end) + (ypop_change(end) - ypop_yield2(end))*delta_t; % xn + Zuwachs - Ertrag
end

%subplot(2,2,1);
plot(t*delta_t,pop,'k',t*delta_t,pop_change*10,'k:');
axis([ 0 duration*delta_t/2 0 K ]);
%title('Entwicklung der Population ohne äussere Einflüsse');
legend('Population',['Zuwachs mal Faktor 10']);
legend('boxoff');
legend('Location','northoutside');
xlabel('Zeit');
ylabel('Anzahl Tiere');

fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 7 5.5];
print(['../Dokumentation/Diagramme/wachstum_ohne_einfluesse.png'],'-dpng','-r300');


dy = @(y) r.*(1-(y./K)).*y; % Veränderung der Population (ohne Einflüsse)
yield_from_pop1 = @(y) E1.*y; % Möglicher Ertrag von der Population (ohne Einflüsse)
yield_from_pop2 = @(y) E2.*y;

%max_yield = r*K/4; % Maximaler Ertrag mit E = r/2
max_pop1 = (r-E1)*(K/r); % Schnittpunkt von Ertrag und Veränderung: E * y = dy => E*y = r(1-y/K)*y => E = r - y*(r/k) => y = (r-E)*(K/r) 
max_pop2 = (r-E2)*(K/r);
max_yield1 = yield_from_pop1(max_pop1);
max_yield2 = yield_from_pop2(max_pop2);

y = [1:K];

plot(y,dy(y),'k',y,yield_from_pop1(y),'k--',y,yield_from_pop2(y),'k:',[max_pop2],[max_yield2],'ok',[max_pop1],[max_yield1],'ok');
legend('Zuwachs','Ertrag für E=r/2','Ertrag für E=r/3','Schnittpunkte Zuwachs / Ertrag');
legend('boxoff');
legend('Location','northoutside');
xlabel('Population');
ylabel('Zuwachs / Ertrag');

fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 7 7];
print(['../Dokumentation/Diagramme/zuwachs_ertrag_zu_population.png'],'-dpng','-r300');

%{
subplot(2,2,3);
plot(t*delta_t,ypop,[1,duration],[max_pop,max_pop],'k');
axis([ 0 duration*delta_t 0 K ]);
title(['Entwicklung der Population mit Fangintensität r/',num2str(1/(E/r))]);
legend('Population',['Max: ',num2str(round(max_pop))]);
legend('Location','northwest');
xlabel('Zeit');
ylabel('Anzahl Tiere');
%}

% für E1
plot(t*delta_t,ypop_change,'k',t*delta_t,ypop_yield1,'k--',t*delta_t,ypop_change-ypop_yield1,'k:');
legend('Zuwachs','Ertrag',['Differenz von Ertrag und Zuwachs']);
legend('boxoff');
legend('Location','northoutside');
xlabel('Zeit');
ylabel('Anzahl Tiere');

fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 7 7];
print(['../Dokumentation/Diagramme/zuwachs_etrag_auf_zeit1.png'],'-dpng','-r300');


%für E2
plot(t*delta_t,ypop_change,'k',t*delta_t,ypop_yield2,'k--',t*delta_t,ypop_change-ypop_yield2,'k:');
legend('Zuwachs','Ertrag',['Differenz von Ertrag und Zuwachs']);
legend('boxoff');
legend('Location','northoutside');
xlabel('Zeit');
ylabel('Anzahl Tiere');

fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 7 7];
print(['../Dokumentation/Diagramme/zuwachs_etrag_auf_zeit2.png'],'-dpng','-r300');



