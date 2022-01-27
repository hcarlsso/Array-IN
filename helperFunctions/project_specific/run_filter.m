function res = run_filter(sensorData, initData, my_settings, S_ref, myFilter)
%RUN_FILTER Run filter and calculate error 
%   Detailed explanation goes here
res = struct;
[res.filt, res.pred] = myFilter(sensorData, initData, my_settings);
err = struct;
if isfield(S_ref,"R")
    try
        err.R = errorSO3(res.filt.R, S_ref.R);
    catch
        warning('Angle Error is too high.');
    end

end

if isfield(S_ref,"v")
    err.v = res.filt.v - S_ref.v;
end

if isfield(S_ref,"p")
    err.p = res.filt.p - S_ref.p;
end

if isfield(S_ref,"w") && isfield(res.filt,"w")
    err.w = res.filt.w - S_ref.w;
end

if isfield(S_ref,"omega_dot")
    err.omega_dot = res.pred.omega_dot - S_ref.omega_dot;
end

if isfield(S_ref,"v_dot")
    err.v_dot = res.pred.v_dot - S_ref.v_dot;
end

res.err = err;

end


