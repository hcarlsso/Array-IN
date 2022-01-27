function [norm_v] = norm_time(x)
%NORM_TIME Summary of this function goes here
%   Detailed explanation goes here

norm_v = sqrt(sum(x.^2,1));
end

