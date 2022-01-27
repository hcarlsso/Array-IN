function [R, Q] = rq(T)
%RQ RQ factorization
%   Same as QR and R have positive diagoanls 

[Q,~] = qr(flipud(T)');
Q = fliplr(Q); % Upper triangularize T{1} from the left
Q = Q*diag(diag(sign(Q))); % To not change coordinate system orientation
Q = Q';

R = T*Q';

end

