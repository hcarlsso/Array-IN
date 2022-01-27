function [u, Qu] = lsq_triad(y,Q)
%LSQ_TRIAD Weighted Mean of triad
%   y = Hu + e , e ~ N(0,Q)
%  u = (H'*Q^{-1}*H)^{-1}(H'*Q^{-1}*y)
% Where u is triad
assert(mod(size(y,1),3) == 0)
assert(size(Q,1) == size(Q,2))

N = size(y,1)/3;
H = repmat(eye(3), N, 1);
L = chol(Q, "lower");

t1 = H'/L;
t2 = (L')\y;
u = (t1 * t1')\(t1*t2);
Qu = inv(t1 * t1');

end

