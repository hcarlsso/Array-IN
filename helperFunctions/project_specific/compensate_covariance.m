function [Q_u] = compensate_covariance(Q_y,T)
%COMPENSATE_MEASUREMENTS Summary of this function goes here
%   Detailed explanation goes here

L = chol(Q_y, "lower");

q = T\L;

Q_u = q*q';

end

