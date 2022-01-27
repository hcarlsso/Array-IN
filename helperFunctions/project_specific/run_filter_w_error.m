function res = run_filter_w_error(sensorData, initData, my_settings, S_ref, myFilter)
%RUN_FILTER Run filter and calculate error 
%   Detailed explanation goes here
res = struct;
[res.filt, res.pred] = myFilter(sensorData, initData, my_settings);
err = struct;
err.filt = compute_error(res.filt, S_ref);
err.pred = compute_error(res.pred, S_ref);
res.err = err;

end


