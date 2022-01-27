function [X_triu_vec] = get_triu_vec(X)
%GET_TRIU Summary of this function goes here
%   Detailed explanation goes here
X_triu_vec = X(triu(true(size(X))));

end

