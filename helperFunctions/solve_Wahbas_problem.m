function [R] = solve_Wahbas_problem(W,V)
%solve_Wahbas_problem Estimate initial rotation matrix from gravity 
%   R = argmin sum_{k,n} || w_{k,n} - R*v_{k,n}||^2
%  where R in SO(3).
assert(all(size(W) == size(V)))
N = size(W,2);
K = size(W,1)/3;
B = zeros(3);
inds = reshape(1:3*K,3,[]);
for n = 1:N
    for k = 1:K
        kk = inds(:,k);
        B = B + W(kk,n)*V(kk,n)';
    end
end

[U,~,V] = svd(B);
M = eye(3);
M(3,3) = det(U)*det(V);
R = U*M*V';

end

