function [A] = compute_A_non_center(r_tot, T)
%COMPUTE_AS The matrix for the rotation 
%
% As = compute_As(r_tot)
% Where r_tot is centered.

K = size(r_tot,2); % Number of acc triads

R_skew = cell(K,1);
for k = 1:K
    R_skew{k} = skew_sym(r_tot(:,k));
end
H = [-cat(1,R_skew{:}), repmat(eye(3),K,1)];

if nargin == 2
    H = matrix3d2blkdiag(T)*H;
end

A = (H'*H)\H';

end

