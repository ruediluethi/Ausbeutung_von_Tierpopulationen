clear;
close all;

for j = [1:16]

    j
    
    K = 300; % Biotop Limit

    % Verhalten der Arten ohne Kontakt
    rv = 0.5*rand() % Reproduktionsrate vom Plankton
    rw = 0; % Sterberate der Wale (wenn sie kein Futter finden)

    % Was passiert bei der Begegnung?
    alpha = 0.01; % Wahrscheinlichkeit einer Begegnung
    lv = 0.5*rand() % Sterberate vom Plankton 
    lw = 0.5*rand() % Reproduktion wenn sich der Wal satt gegessen hat

    beta = 0.5*rand()

    %v = [0]; % Plankton
    %w = [K*(1+(beta/rw))] % Wale

    v = [100];
    w = [100];

    delta_t = .001;
    duration = 1000;
    t = 1:duration/delta_t;
    for i = [t(1):t(end-1)]

        delta_v = +rv*(1-(v(end)+w(end))/K)*v(end) - lv*alpha*v(end)*w(end);
        delta_w = -rw*(1-(v(end)+w(end))/K)*w(end) + lw*alpha*v(end)*w(end) - beta*w(end);

        v_next = v(end) + delta_v*delta_t;
        w_next = w(end) + delta_w*delta_t;

        if v_next < 0
            v_next = 0
        end
        if w_next > K*K
            w_next = K*K
        end

        v(end+1) = v_next;
        w(end+1) = w_next;

    end

    subplot(4,4,j);
    %plot(t*delta_t,w,'k',t*delta_t,v,'k--',[0,duration],[K,K],t*delta_t,w+v,'r');
    %plot(t*delta_t,w,'k',t*delta_t,v,'k--');
    plot(t*delta_t,w,t*delta_t,v);
    % title(['rv',num2str(rw),'; lv:',num2str(lv),'; lw:',num2str(lw),'; beta:',num2str(beta)]);
    
end
