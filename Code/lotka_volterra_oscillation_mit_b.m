clear;
close all;

for j = [1:1]

    K = 300; % Biotop Limit

    j
    
    % Verhalten der Arten ohne Kontakt
    %rv = 0.1+0.2*rand() % Reproduktionsrate vom Plankton
    %rv = 0.17+0.01*rand()
    %rv = 0.0572;
    rv = 0.178;
    %rw = 0.1+0.2*rand() % Sterberate der Wale (wenn sie kein Futter finden)
    %rw = 0.16+0.01*rand()
    %rw = 0.1058;
    rw = 0.169;

    % Was passiert bei der Begegnung?
    alpha = 0.001; % Wahrscheinlichkeit einer Begegnung
    %lv = 0.1+0.2*rand() % Sterberate vom Plankton 
    %lv = 0.10+0.01*rand()
    %lv = 0.2754;
    lv = 0.106;
    %lw = 0.1+0.2*rand() % Reproduktion wenn sich der Wal satt gegessen hat
    %lw = 0.26+0.01*rand()
    %lw = 0.3671;
    lw = 0.261;

    %beta = 0.01+0.02*rand()
    %beta = 0.02+0.01*rand()
    %beta = 0.0120;
    beta = 0.021;

    %v = [0]; % Plankton
    %w = [K*(1+(beta/rw))] % Wale

    v = [100];
    w = [100];

    delta_t = .01;
    duration = 300;
    t = 1:duration/delta_t;
    for i = [t(1):t(end-1)]

        delta_v = +rv*(1-(v(end)+w(end))/K)*v(end) - lv*alpha*v(end)*w(end);
        delta_w = -rw*(1-(v(end)+w(end))/K)*w(end) + lw*alpha*v(end)*w(end) - beta*w(end);

        v_next = v(end) + delta_v*delta_t;
        w_next = w(end) + delta_w*delta_t;

        v(end+1) = v_next;
        w(end+1) = w_next;

    end
    
    %subplot(4,4,j);
    %plot(t*delta_t,w,t*delta_t,v);
    
    plot(t*delta_t,w,'k',t*delta_t,v,'k--');
    legend('Räuber','Beute');
    legend('boxoff');
    legend('Location','northoutside');
    xlabel('Zeit');
    ylabel('Anzahl Tiere');

    fig = gcf;
    fig.PaperUnits = 'centimeters';
    fig.PaperPosition = [0 0 7 7];
    print(['../Dokumentation/Diagramme/beute_raeuber_oszillation_mit_b.png'],'-dpng','-r300');

    plot(w,v,'k');
    legend('Räuber Beute Korrelation');
    legend('boxoff');
    legend('Location','northoutside');
    xlabel('Räuber');
    ylabel('Beute');

    fig = gcf;
    fig.PaperUnits = 'centimeters';
    fig.PaperPosition = [0 0 7 7];
    print(['../Dokumentation/Diagramme/beute_raeuber_korrelation_mit_b.png'],'-dpng','-r300');
end
