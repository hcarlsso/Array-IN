function [D,L, Q] = factorize_T(T)
%FACTORIZE_T Factorize scale matrix as T = D*L*Q
%   D: Diagonal matrix with scale factors
%   L: Upper triangular matrix with unit diagonal. Account for
%   non-orthogonalities 
%   Q: Rotation matrix 
[R,Q] = rq(T);

S = diag(R);
D = diag(S);
L = D\R;


end

