function w_hat = HatSO3(w)

w_hat = [0 -w(3) w(2);...
         w(3) 0 -w(1);...
         -w(2) w(1) 0];
     
% w_hat = zeros(3,3);
% w_hat(2,1) = w(3);
% w_hat(3,1) = -w(2);
% 
% w_hat(1,2) = -w(3);
% w_hat(3,2) = w(1);
% 
% w_hat(1,3) = w(2);
% w_hat(2,3) = -w(1);