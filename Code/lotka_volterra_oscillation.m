clear;
close all;

K = 300; % Biotop Limit

% Verhalten der Arten ohne Kontakt
rv = 0.2; % Reproduktionsrate vom Plankton
rw = 0.2; % Sterberate der Wale (wenn sie kein Futter finden)

% Was passiert bei der Begegnung?
alpha = 0.001; % Wahrscheinlichkeit einer Begegnung
lv = 0.2; % Sterberate vom Plankton 
lw = 0.2; % Reproduktion wenn sich der Wal satt gegessen hat

v = [100];
w = [100];

delta_t = .1;
duration = 300;
t = 1:duration/delta_t;
for i = [t(1):t(end-1)]

    delta_v = +rv*(1-(v(end)+w(end))/K)*v(end) - lv*alpha*v(end)*w(end);
    delta_w = -rw*(1-(v(end)+w(end))/K)*w(end) + lw*alpha*v(end)*w(end);
    
    v(end+1) = v(end) + delta_v*delta_t;
    w(end+1) = w(end) + delta_w*delta_t;
    
end

plot(t*delta_t,w,'k',t*delta_t,v,'k--');
legend('Räuber','Beute');
legend('boxoff');
legend('Location','northoutside');
xlabel('Zeit');
ylabel('Anzahl Tiere');

fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 7 7];
print(['../Dokumentation/Diagramme/beute_raeuber_oszillation.png'],'-dpng','-r300');

plot(w,v,'k');
legend('Räuber Beute Korrelation');
legend('boxoff');
legend('Location','northoutside');
xlabel('Räuber');
ylabel('Beute');

fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 7 7];
print(['../Dokumentation/Diagramme/beute_raeuber_korrelation.png'],'-dpng','-r300');
