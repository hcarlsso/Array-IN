function [S] = interpolate_pos_and_rotation(S,imu_time, rig_time)
%INTERPOLATE_POS_AND_ROTATION Interpolate IMU pos and rotation estimates 
% to rig time
S.p_rig_time = zeros(3, length(rig_time));
for i = 1:3
    S.p_rig_time(i,:) = interp1(imu_time, S.p(i,:), rig_time, "pchip");
end


% Find the fractional indices using linear interpolation 
inds_time = interp1(imu_time, 1:length(imu_time), rig_time, "linear");
R_rig_time = zeros(3,3,length(inds_time));
for n = 1:length(inds_time)
    
    frac = inds_time(n) - floor(inds_time(n));
    if frac > 1
        warning("fraction larger than 1")
    elseif frac == 0
        % Same point in time
        R_rig_time(:,:,n) = S.R(:,:, round(inds_time(n)));
    else
        % Calculate the rotation vector and scale it
        left_ind = floor(inds_time(n));
        right_ind = left_ind + 1;
        R_left = S.R(:,:, left_ind);
        R_right = S.R(:,:, right_ind);
        
        theta = logSO3(invSO3(R_left)*R_right);
        R_rig_time(:,:,n) = R_left*expSO3(frac*theta);
    end
end
S.R_rig_time = R_rig_time;

end

