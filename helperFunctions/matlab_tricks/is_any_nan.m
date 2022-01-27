function [t] = is_any_nan(x)
%IS_ANY_NAN Is any value NaN
t = any(isnan(x),"all");

end

