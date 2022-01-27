function d = spline_derivative(t, w, j)

if nargin < 3
    j = 1;
end
d = zeros(size(w));
for i = 1:3
    pp = spline(t, w(i,:)');
    qq = ppdiff(pp,j);    
    d(i,:) = ppval(qq,t);    
end

end

