function [As, R_square] = compute_As(r_tot)
%COMPUTE_AS The matrix for the rotation 
%
% As = compute_As(r_tot)
% Where r_tot is centered.

assert( all(abs(mean(r_tot,2)) < 10*eps))
K = size(r_tot,2); % Number of acc triads

R_skew = zeros(3,3,K);
for k = 1:K
    R_skew(:,:,k) = skew_sym(r_tot(:,k));
end
R_square = zeros(3,3);
for k = 1:K
    R_square = R_square + R_skew(:,:,k)'*R_skew(:,:,k);
end
As = zeros(3,3,K);
for k = 1:K
    As(:,:,k) = R_square\R_skew(:,:,k);
end

end

