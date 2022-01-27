function plot_eigen_observability(D, mask, mytitle)
%PLOT_EIGEN_OBSERVABILITY.M Summary of this function goes here
%   Detailed explanation goes here


figure(); hold on 
N = length(mask);
iters = 1:length(mask);
plot(iters(mask), D(:,mask)')
plot(1:N, ones(N,1),"r-")
if sum(~mask) > 0
    plot(iters(~mask), ones(sum(~mask),1),"rx")
end
set(gca, "YScale", "log")
title(sprintf("Eigenvalues of Dim.-less and norm. Covariance, %s", mytitle))
grid on 

end

