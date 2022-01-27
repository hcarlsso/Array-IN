function [y] = arrayfun_parfor(f,x)
%ARRAYFUN_PARFOR Summary of this function goes here
%   Detailed explanation goes here
y = zeros(size(x));
tic
parfor i = 1:numel(x)
    y(i) = f(x(i));
end
toc

end

