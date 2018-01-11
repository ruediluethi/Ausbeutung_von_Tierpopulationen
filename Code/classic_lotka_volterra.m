clear;
close all;

%hold on;

% from https://de.wikipedia.org/wiki/Lotka-Volterra-Gleichungen

prey = [100]; % Anzahl der Beutelebewesen
prey_prod_rate = 1; % Reproduktionsrate der Beute ohne Störung und bei großem Nahrungsangebot

predator = [100]; % Anzahl der Räuber
predator_die_rate = 0.5; % Sterberate der Räuber, wenn keine Beute vorhanden ist

predator_eat_rate = 0.01; % Fressrate der Räuber pro Beutelebewesen = Sterberate der Beute pro Räuber
predator_prod_rate = 0.01; % Reproduktionsrate der Räuber pro Beutelebewesen


biotop_size = 300;

duration = 300;
delta_t = .1;
t = 1:duration/delta_t;
for i = [t(1):t(end-1)]
    k = (prey(end)+predator(end))/biotop_size;
    
    r_prey = prey_prod_rate - predator_eat_rate*predator(end);
    delta_prey = r_prey*(1-k)*prey(end);
    
    r_predator = predator_die_rate - predator_prod_rate*prey(end);
    delta_predator = r_predator*(1-k)*predator(end);
    
    prey(end+1) = prey(end) +  delta_prey*delta_t;
    predator(end+1) = predator(end) -  delta_predator*delta_t;
end

subplot(1,2,1);
p = plot(t,prey,t,predator);
legend('prey','predator');
axis([0 duration/delta_t 0 biotop_size]);

subplot(1,2,2);
plot(prey,predator,'k');