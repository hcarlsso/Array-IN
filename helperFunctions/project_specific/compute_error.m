function [err] = compute_error(S,S_ref)
%COMPUTE_ERROR Summary of this function goes here
%   Detailed explanation goes here
err = struct;
if isfield(S_ref,"R") && isfield(S,"R")
    try
        err.R = errorSO3(S.R, S_ref.R);
    catch
        warning('Angle Error is too high.');
    end
end

if isfield(S_ref,"v") && isfield(S,"v")
    err.v = S.v - S_ref.v;
end

if isfield(S_ref,"p") && isfield(S,"p")
    err.p = S.p - S_ref.p;
end

if isfield(S_ref,"w") && isfield(S,"w")
    err.w = S.w - S_ref.w;
end

if isfield(S_ref,"omega_dot") && isfield(S,"omega_dot")
    err.omega_dot = S.omega_dot - S_ref.omega_dot;
end

if isfield(S_ref,"v_dot") && isfield(S,"v_dot")
    err.v_dot = S.v_dot - S_ref.v_dot;
end

if isfield(S_ref,"s") && isfield(S,"s")
    err.s = S.s - S_ref.s;
end

if isfield(S_ref,"b_g") && isfield(S,"b_g")
    err.b_g = S.b_g - S_ref.b_g;
end

if isfield(S_ref,"b_s") && isfield(S,"b_s")
    err.b_s = S.b_s - S_ref.b_s;
end

if isfield(S_ref,"T_a") && isfield(S,"T_a")
    err.T_a = S.T_a - S_ref.T_a;
end

if isfield(S_ref,"b_omega_dot") && isfield(S,"b_omega_dot")
    err.b_omega_dot = S.b_omega_dot - S_ref.b_omega_dot;
end

end

