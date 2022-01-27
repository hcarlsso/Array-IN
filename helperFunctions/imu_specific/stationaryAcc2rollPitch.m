function [roll, pitch] = stationaryAcc2rollPitch(u)
%GET_ROLL_PITCH Summary of this function goes here
%   Detailed explanation goes here
f_x=mean(u(1,:));
f_y=mean(u(2,:));
f_z=mean(u(3,:));

roll=atan2(-f_x,f_z);
pitch=atan2(f_y,sqrt(f_x^2+f_z^2));
end

