function [R] = rotationMatrixFromTwoUnitVectors(a,b)
%rotationMatrixFromTwoUnitVectors Find rotation matrix from a to b
%   Detailed explanation goes here
a = a./norm(a);
b = b./norm(b);

v = cross(a,b);
s = norm(v);
c = dot(a,b);

R = eye(3) + skew_sym(v) + skew_sym(v)^2 *(1-c)/s^2;

end

