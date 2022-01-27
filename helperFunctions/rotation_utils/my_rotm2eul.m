function [E] = my_rotm2eul(R)
%MY_ROTM2EUL Rotation matrix to euler angles [roll, pitch, yaw]
%
%   E = my_rotm2eul(R)
%
%   Roll: around x-axis
%   Pitch: around y-axis
%   Yaw: around z-axis (heading)
%   R (3,3,N) ->  E (3, N) 

% rotm2eul gives [yaw, pitch, roll] intrinsic rotation
% R = R_z(yaw)*R_y(pitch)*R_z(roll)
% unwrap: adds 2pi when wrapping 
% flipud to get in order [roll, pitch, yaw]
E = flipud(unwrap(rotm2eul(R, 'ZYX'))'); 

end

