function [T,b] = estimate_T_and_b(y,u,Q)
%ESTIMATE_T_AND_B Summary of this function goes here
%   Detailed explanation goes here
assert(all(size(y) == size(u)))
A = zeros(12,12);
b = zeros(12,2);
for n = 1:size(y,2)
    H_n = [kron(u(:,n)',eye(3)) eye(3)];
    Ht_Q_inv = H_n'/Q;
    A = A + Ht_Q_inv*H_n;
    b = b + Ht_Q_inv*y(:,n);
end
Tb = A\b;

T = reshape(Tb(1:9),3,3);
b = Tb(10:12);

end

