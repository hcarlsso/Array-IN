function R_inter = interpolate_rotation(t, R, t_inter)
%INTERPOLATE_POS_AND_ROTATION Interpolate IMU pos and rotation estimates 
% R_inter = interpolate_rotation(t, R, t_inter)
% t and R are data points 
% t_inter is the time points where interpolation should occur
% R_inter is the interpolated rotation matrix

S = size(R);
assert(length(t) == S(3))
assert(all(S(1:2) == [3 3]))


% Find the fractional indices using linear interpolation 
inds_imu_time = interp1(t, 1:length(t), t_inter, "linear");
R_inter = NaN(3,3,length(inds_imu_time));
for n = 1:length(inds_imu_time)
    % Extrapolation set to NaN
    if isnan(inds_imu_time(n))
        continue
    end
    
    frac = inds_imu_time(n) - floor(inds_imu_time(n));
    if frac > 1
        warning("fraction larger than 1")
    elseif frac == 0
        % Same point in time
        R_inter(:,:,n) = R(:,:, round(inds_imu_time(n)));
    else
        % Calculate the rotation vector and scale it
        left_ind = floor(inds_imu_time(n));
        right_ind = left_ind + 1;
        R_left = R(:, :, left_ind);
        R_right = R(:, :, right_ind);
        
        theta = logSO3(invSO3(R_left)*R_right);
        R_inter(:,:,n) = R_left*expSO3(frac*theta);
    end
end


end

