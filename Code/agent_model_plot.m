clear;
close all;

data = importdata('data/export.txt');
data = data';

t = [1:length(data)];
delta_t = 0.3;

% begin of the simulation
plot(t*delta_t,data(1,:),'k',t*delta_t,data(2,:),'k--');
axis([0 200 0 max(data(1,:))+min(data(2,:))]); 

legend('Räuber','Beute');
legend('boxoff');
legend('Location','northoutside');
xlabel('Zeit');
ylabel('Anzahl Tiere');

fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 7 7];
print(['../Dokumentation/Diagramme/agent_model_start.png'],'-dpng','-r300');

% oscillating behavior
plot(t*delta_t,data(1,:),'k',t*delta_t,data(2,:),'k--');
axis([998 1174 0 max(data(1,:))+min(data(2,:))]); 

legend('Räuber','Beute');
legend('boxoff');
legend('Location','northoutside');
xlabel('Zeit');
ylabel('Anzahl Tiere');

fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 7 7];
print(['../Dokumentation/Diagramme/agent_model_oscillation.png'],'-dpng','-r300');