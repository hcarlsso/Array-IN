function [s,l,q] = get_T_components(T)
%GET_T_COMPONENTS Get the components of the T matrix
%   s: scale factors 
%   l: angles for non-orthogonalities
%   q: rotation vector 
[S,L,Q] = factorize_T(T);

s = diag(S);

l = zeros(3,1);
l(1) = L(1,2);
l(2) = L(1,3);
l(3) = L(2,3);

q = logSO3(Q);
end

