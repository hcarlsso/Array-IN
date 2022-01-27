function [h, g] = pnumerical_hessian_forward_diff(f,x)

epsilon = 1e-5; 
epsilon_inv = 1/epsilon;

nx = length(x); % Dimension of the input x;
f0 = feval(f, x); % caclulate f0, when no perturbation happens

f_e = zeros(nx,1);
g = zeros(nx,1);
% Do perturbation
parfor i = 1:nx
    x_ = x;
    x_(i) =  x(i) + epsilon;
    f_e(i) = feval(f, x_);
    
    g(i) = (f_e(i) - f0) .* epsilon_inv;
end

Boolind = triu(true(nx,nx));
Boolind = Boolind(:);

n_2e = nx*(nx + 1)/2;
f_2e_vec = zeros(n_2e, 1);

inds = triu(reshape(1:nx^2,nx,nx));
inds_vec = inds(Boolind);

parfor n = 1:n_2e
    ind = inds_vec(n);
    [i,j] = ind2sub([nx,nx], ind);

    x_ = x;
    if i == j
        x_(i) =  x(i) + 2*epsilon;
    else
        x_(i) =  x(i) + epsilon;
        x_(j) =  x(j) + epsilon;
    end
    f_2e_vec(n) = feval(f, x_);
end

f_2e = zeros(nx, nx);
f_2e(Boolind) = f_2e_vec;

f_2e = f_2e + triu(f_2e,1)';
h = zeros(nx,nx);
for i = 1:nx
    for j = 1:nx
        h(i,j) = (f_2e(i,j) - f_e(i) - f_e(j)  + f0)*epsilon_inv^2;
    end
end

end