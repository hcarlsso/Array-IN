function [ x_dual_hat ] = dualHatSO3( x )
%w_hat*x = x_dual_hat*w

x_dual_hat = - HatSO3(x);


end

