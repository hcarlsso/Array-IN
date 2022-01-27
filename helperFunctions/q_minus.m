function [dtheta] = q_minus(q1,q2)
%UNTITLED17 Summary of this function goes here
%   Detailed explanation goes here
% Half the angle 
o1 = ones(length(q1),1);
o1(parts(q1) < 0) = -1;
q1 = q1.*o1;

o2 = ones(length(q2),1);
o2(parts(q2) < 0) = -1;
q2 = q2.*o2;

dtheta = compact(log(conj(q1).*q2)).*2;
assert(all(abs(dtheta(:,1)) < 100*eps));
dtheta = dtheta(:,2:4); %

end

