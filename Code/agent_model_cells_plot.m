clear;
close all;

data = importdata('data/multi_export.txt');
data = data';

t = [1:length(data)];
delta_t = 0.3;
start_time = 190;
end_time = 440;

% cell A
plot(t*delta_t,data(1,:),'k',t*delta_t,data(2,:),'k--');
axis([start_time end_time 0 max(max(data))+min(min(data))]);

legend('Räuber','Beute');
legend('boxoff');
legend('Location','northoutside');
xlabel('Zeit');
ylabel('Anzahl Tiere');

fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 7 7];
print(['../Dokumentation/Diagramme/agent_model_cell_A.png'],'-dpng','-r300');

% cell B
plot(t*delta_t,data(2,:),'k',t*delta_t,data(3,:),'k--');
axis([start_time end_time 0 max(max(data))+min(min(data))]);

legend('Räuber','Beute');
legend('boxoff');
legend('Location','northoutside');
xlabel('Zeit');
ylabel('Anzahl Tiere');

fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 7 7];
print(['../Dokumentation/Diagramme/agent_model_cell_B.png'],'-dpng','-r300');