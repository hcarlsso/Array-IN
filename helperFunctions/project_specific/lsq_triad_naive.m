function [u, Qu] = lsq_triad_naive(y,Q)
%LSQ_TRIAD Summary of this function goes here
%   y = Hu + e , e ~ N(0,Q)
%  u = (H'*Q^{-1}*H)^{-1}(H'*Q^{-1}*y)
% Where u is triad
assert(mod(size(y,1),3) == 0)
assert(size(Q,1) == size(Q,2))

N = size(y,1) / 3;
H = kron(ones(N,1),eye(3));
HT_Q_inv = (H')/Q;

u = (HT_Q_inv * H)\(HT_Q_inv * y);

Qu = inv(HT_Q_inv * H);

end



