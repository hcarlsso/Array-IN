function [y] = get_triad_form(x)
%GET_TRIAD_FORM Summary of this function goes here
%   Detailed explanation goes here
N_sens = size(x,1);
assert(mod(N_sens,3) == 0)
N_imu = N_sens/3;

y = reshape(x, 3, N_imu, []);

end

