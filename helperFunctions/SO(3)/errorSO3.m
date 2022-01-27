function [err] = errorSO3(Rhat, Rtrue)
%UNTITLED Summary of this function goes here
%   Need to be same length 

N = size(Rhat,3);

%% Calculate errors
err = zeros(3, N);
for n = 1:N
    if ndims(Rtrue) == 3
        err(:, n) = logSO3(invSO3(Rhat(:,:,n))*Rtrue(:,:,n));
    else
        err(:, n) = logSO3(invSO3(Rhat(:,:,n))*Rtrue);
    end
end

end

