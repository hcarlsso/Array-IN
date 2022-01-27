function plot_error_ins(o,N, mytitle)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
f = figure(N+1);
set(f,'WindowStyle','docked')
clf
plot(o.p_norm, "x")
ylabel("Norm position error [m]")
xlabel("# Exo.")
grid on
title(mytitle);

f = figure(N+2);
set(f,'WindowStyle','docked')
clf
plot(rad2deg(o.R_norm), "x")
ylabel("Angle Error [deg]")
xlabel("# Exo.")
grid on
title(mytitle);

f = figure(N+3);
set(f,'WindowStyle','docked')
clf
plot(o.in_time, "x")
ylabel("Accumulated time [s]")
xlabel("# Exo.")
grid on
title(mytitle);

f = figure(N+4);
set(f,'WindowStyle','docked')
clf
plot(o.in_time,o.p_norm, "x")
xlabel("Accumulated time [s]")
ylabel("Norm position error [m]")
grid on
title(mytitle);

f = figure(N+5);
set(f,'WindowStyle','docked')
clf
plot(o.in_time,rad2deg(o.R_norm), "x")
xlabel("Accumulated time [s]")
ylabel("Norm angle error [deg]")
grid on 
title(mytitle);

end

