function plot_angular_velocities(t, inp)
% Angular velocity in rotating frame

w_b = inp.w_b;
w_dot_b = inp.w_dot_b;

phi = inp.phi;
phi_dot = inp.phi_dot;
phi_dot_2 = inp.phi_dot_2;

theta = inp.theta;
theta_dot = inp.theta_dot;
theta_dot_2 = inp.theta_dot_2;


subplot(3,2,1)
plot(t, rad2deg(w_b(1,:)), "r",t, rad2deg(w_b(2,:)), "g",t,rad2deg(w_b(3,:)), "b");
grid on
legend("r", "\phi", "\theta")
title("\omega in rotating frame")
ylabel("deg/s")

subplot(3,2,3)
plot(t, rad2deg(w_dot_b(1,:)), "r",t, rad2deg(w_dot_b(2,:)), "g",t,rad2deg(w_dot_b(3,:)), "b");
grid on
legend("r", "\phi", "\theta")
title("\omega dot in rotating frame")
ylabel("deg/s^2")

% subplot(3,2,[1 2])
% plot(t, rad2deg(w_n(1,:)), "r",t, rad2deg(w_n(2,:)), "g",t,rad2deg(w_n(3,:)), "b");
% grid on
% legend("x", "y", "z")
% title("\omega in navigation")
% ylabel("deg/s")

% subplot(3,2,[2 2])
% plot(t, rad2deg(w_dot_n(1,:)), "r",t, rad2deg(w_dot_n(2,:)), "g",t,rad2deg(w_dot_n(3,:)), "b");
% grid on
% legend("x", "y", "z")
% title("\omega dot in navigation")
% ylabel("deg/s^2")


subplot(3,2,2)
plot(t,rad2deg(phi), "g", t, rad2deg(theta),"b--");
grid on 
legend( "\phi","\theta")
ylabel("deg")

subplot(3,2,4)
plot(t,rad2deg(phi_dot), "g", t, rad2deg(theta_dot),"b--");
grid on 
legend( "\phi dot","\theta dot")
ylabel("deg/s")

subplot(3,2,6)
plot(t,rad2deg(phi_dot_2), "g", t, rad2deg(theta_dot_2),"b--");
grid on 
legend( "\phi dot_2","\theta dot_2")
ylabel("deg/s^2")

end
