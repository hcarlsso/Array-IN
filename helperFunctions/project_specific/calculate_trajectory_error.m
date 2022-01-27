function [err] = calculate_trajectory_error(S_hat,S_true,varargin)
%CALCULATE_TRAJECTORY_ERROR Summary of this function goes here
%   Detailed explanation goes here
if nargin > 2
    section = varargin{1};
else
    section = 1:size(S_true.R,3);
end
err = struct;
err.R = errorSO3(S_hat.R, S_true.R(:,:,section));
err.R_deg = rad2deg(err.R);
if isfield(S_hat, "w")
    err.w = S_hat.w - S_true.w(:,section); 
    err.w_deg = rad2deg(err.w);
end
err.p = S_hat.p - S_true.p(:,section);
err.v = S_hat.v - S_true.v(:,section);

if isfield(S_hat, "b_a")
    inds_bias = 1:size(S_hat.b_a,1);
    err.b_a = S_hat.b_a - S_true.b_a(inds_bias,section);    
end
if isfield(S_hat, "b_g")
    err.b_g = S_hat.b_g - S_true.b_g(:,section); 
    err.b_g_deg = rad2deg(err.b_g);
end

end

