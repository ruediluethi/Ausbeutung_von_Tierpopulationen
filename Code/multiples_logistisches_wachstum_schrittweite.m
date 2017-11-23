clear;
close all;

%duration = 600;
%r = 0.06;
%K = 150000;

delta = 0.1;
duration = 400;
r = 1;
K = 100;

E = r/2; % max zulässiger Ertrag, damit weiterhin stabil

t = 1:duration/delta;

length(t)

popA = [1];
popB = [1];

for i = [t(1):t(end-1)]
    
    K_tot = (popA(end)+popB(end))/K;
    
    rA = 1;
    popA_new_born = rA*(1-K_tot)*popA(end)*delta;
    popA_killed_by_B = popB(end)*popA(end)*0.01*delta;
    popA(end+1) = popA(end) + popA_new_born - popA_killed_by_B;
    
    rB = popA(end)/(K-popB(end));
    popB_new_born = rB*(1-K_tot)*popB(end)*delta;
    popB_killed = popB(end)*0.02*delta;
    popB(end+1) = popB(end) + popB_new_born - popB_killed;
    
end

%subplot(2,2,1);
plot(t,popA,t,popB);
axis([0 duration/delta 0 K]);
legend('Population A', 'Population B');
