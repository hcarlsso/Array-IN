function [S_out] = rotate_measurements(S_in,R)
%ROTATE_MEASUREMENTS Summary of this function goes here
%   Detailed explanation goes here
S_out = struct;
S_out.y = R*S_in.y;
S_out.Q = R*S_in.Q*R';
S_out.Q_inv = inv(S_out.Q);
end

