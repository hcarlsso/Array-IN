function [y] = triad_mean(x)
%TRIAD_MEAN mean of triad data from 2D matrix
%   y = triad_mean(x)

N_sens = size(x,1);
assert(mod(N_sens,3) == 0)
N_imu = N_sens/3;

y = reshape(mean(reshape(x, 3, N_imu, []),2),3,[]);


end

