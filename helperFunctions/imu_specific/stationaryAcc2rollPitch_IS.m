function [roll, pitch] = stationaryAcc2rollPitch_IS(u)
%GET_ROLL_PITCH Summary of this function goes here
%   Detailed explanation goes here
f_u=mean(u(1,:));
f_v=mean(u(2,:));
f_w=mean(u(3,:));

roll=atan2(-f_v,-f_w);
pitch=atan2(f_u,sqrt(f_v^2+f_w^2));
end

