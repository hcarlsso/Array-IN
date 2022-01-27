function [w_dot_interp] = w2w_dot_splines(t, w)
%W2W_DOT_SPLINES Interpolate w to w_dot using splines
%
%   w_dot_interp = w2w_dot_splines(t, w)
%
w_dot_interp = zeros(size(w));
for i = 1:3
    pp = spline(t, w(i,:)');
    qq = ppdiff(pp);
    
    w_dot_interp(i,:) = ppval(qq,t);
    
end

end

