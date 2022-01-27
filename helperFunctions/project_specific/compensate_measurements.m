function [u] = compensate_measurements(y,T,b)
%COMPENSATE_MEASUREMENTS Summary of this function goes here
%   Detailed explanation goes here
if ndims(T) == 3
    T_diag = matrix3d2blkdiag(T);
else
    T_diag = T;
end
b = reshape(b,[],1);
u = T_diag\(y - b);
end

