function [D,V,P_norm] = stochastic_observability(P)
%STOCHASTIC_OBSERVABILITY Summary of this function goes here
%   Detailed explanation goes here

assert(ndims(P) == 3)

P0 = P(:,:,1);
n = size(P,1);

assert(isdiag(P0))

F = inv(sqrt(P0));

P_norm = zeros(size(P));


for k = 1:size(P,3)
    P_k_in = P(:,:,k);
    
    P_k_in_1 = F*P_k_in*F;

    % Normalize to unit norm for the eigen values 
    P_norm_k = P_k_in_1./trace(P_k_in_1);
    
    P_norm(:,:,k) = P_norm_k;
    
    
end

% eigenshuffle: Consistent sorting for an eigenvalue/vector sequence
% [Vseq,Dseq] = eigenshuffle(Asequence)

[V, D] = eigenshuffle(P_norm);


end

