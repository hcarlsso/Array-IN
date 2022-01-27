function [y] = triad_norm(x)
%TRIAD_NORM Summary of this function goes here
%   Detailed explanation goes here

N_sens = size(x,1);
assert(mod(N_sens,3) == 0)
N_imu = N_sens/3;

y = reshape(sqrt(sum(get_triad_form(x).^2, 1)),N_imu,[]);

end

