function [d_h_d_omega] = d_h_d_omega(omega,r)
%D_H_D_OMEGA Summary of this function goes here
%   Detailed explanation goes here
N_a = size(r,2);
d_h_d_omega_parts = cell(N_a,1);
omega_hat = HatSO3(omega);
for k = 1:N_a
    r_k = r(:,k);
    d_h_d_omega_parts{k} = (-HatSO3(omega_hat*r_k) - omega_hat*HatSO3(r_k));
end
d_h_d_omega = cat(1, d_h_d_omega_parts{:});

end

