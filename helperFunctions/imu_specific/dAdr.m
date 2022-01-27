function [f,J] = dAdr(a,r,w)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

N_a = size(r,2); % Number of acc triads


R_skew = cell(N_a,1);
for k = 1:N_a
    R_skew{k} = skew_sym(r(:,k));
end
H = [-cat(1,R_skew{:}), repmat(eye(3),N_a,1)];


O2 = skew_sym(w)^2;
h = reshape(O2*r, [],1);
a_1 = a - h;
A_1 = H'*H;
A_1_inv = inv(A_1);

f = A_1\H'*a_1;

assert(length(f) == 6)
A_2 = kron(eye(N_a),O2);
A_3 = kron(f', -A_1_inv);
A_4 = kron(a_1', A_1_inv);
A_5 = -A_1\H'*A_2;

K = commutation_matrix(3*N_a,6);
A_6 = kron(H', eye(6))*K;
A_7 = kron(eye(6), H');
A_8 = A_3*A_6 + A_3*A_7 + A_4*K;

B_1 = skew_sym([-1 0 0]);
B_2 = skew_sym([0 -1 0]);
B_3 = skew_sym([0 0 -1]);

A_9 = [kron(eye(N_a), -B_1);
    kron(eye(N_a), -B_2);
    kron(eye(N_a), -B_3);
    zeros(9*N_a, 3*N_a)];

J = A_8 * A_9 + A_5;

assert(all(size(J) == [6,3*N_a]))

end

























