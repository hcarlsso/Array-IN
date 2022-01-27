function w = R2w_central_diff(R,t)
%R2W_CENTRAL_DIFF Rotation matrix 2 angular velocity using central 
%difference 
% 
%   w = R2w_central_diff(R,t)
%
%   Based on:
%   R_{t+1} = R_{t} exp_SO3(w*t)
%   w in body frame

w = nan(3,length(t));

for n = 2:length(t) - 1
    dt = t(n+1) - t(n-1);
    w(:,n) = logSO3(R(:,:,n-1)'*R(:,:,n+1))/dt;
end


end

