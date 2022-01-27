function [d_h_d_omega] = d_h_d_omega_opt(w,r)
%D_H_D_OMEGA Summary of this function goes here
%   Detailed explanation goes here
N_a = size(r,2);
row1 = 1:3:3*N_a;
row2 = 2:3:3*N_a;
row3 = 3:3:3*N_a;
d_h_d_omega = zeros(3*N_a,3);
r1 = r(1,:);
r2 = r(2,:);
r3 = r(3,:);

r1w1 = w(1).*r1;
r1w2 = r1.*w(2);
r1w3 = r1.*w(3);

r2w1 = r2.*w(1);
r2w2 = w(2).*r2;
r2w3 = r2.*w(3);

r3w1 = r3.*w(1);
r3w2 = r3.*w(2);
r3w3 = w(3).*r3;

d_h_d_omega(row1,1) = r2w2 + r3w3;
d_h_d_omega(row2,1) = r1w2 - 2*r2w1;
d_h_d_omega(row3,1) = r1w3 - 2*r3w1;

d_h_d_omega(row1,2) = r2w1 - 2*r1w2;
d_h_d_omega(row2,2) = r1w1 + r3w3;
d_h_d_omega(row3,2) = r2w3 - 2*r3w2;

d_h_d_omega(row1,3) = r3w1 - 2*r1w3;
d_h_d_omega(row2,3) = r3w2 - 2*r2w3;
d_h_d_omega(row3,3) = r1w1 + r2w2;


end

