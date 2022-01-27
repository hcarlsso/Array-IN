function [R_mean, list_r] = average_rotation(Rs, nb_it_max, tol_r)
%average_rotation Average rotation from multiple rotation matrices
%   [R_mean, list_r] = average_rotation(Rs, nb_it_max, tol_r)
%   size(Rs) == [3,3,N], N number of rotations
%   nb_it_max: max number of iterations, default 20 
%   tol_r: tolarance for deviations, default 1e-10
%   R_mean: Average rotation 
%   list_r: residuals in lie algebra 

if nargin == 1
    nb_it_max = 20;
    tol_r     = 1e-10;   % [1]
end
number_rotations = size(Rs,3);
R_mean = Rs(:,:,1); % First approx of R [1]
for nb_it = 1:nb_it_max % [2]
    list_r = nan(3,number_rotations);  % [3]
    for i = 1:number_rotations
        list_r(:,i) = logSO3(R_mean'*Rs(:,:,i));
    end
    r = mean(list_r,2);
    
    fprintf("%d/%d: tol: %.3e / %.3e\n", nb_it, nb_it_max, norm(r), tol_r);
    if norm(r) < tol_r % [4]
        break
    end
    R_mean = R_mean * expSO3(r); % Update [7]
    
end % [8]
if nb_it == nb_it_max
    error('the maximum number of iteration where reached')
end


end

