%% MC 
%% 
% 
% Simulations
% Create noisy measurements and a complicated trajectory.

pathScript = fileparts(mfilename('fullpath'))
pathData = fullfile(pathScript,"data")

mkdir(pathData)

Fs_range = [500,100];
f_rotation_range = [1.5, 10];

data_tot = cell(length(f_rotation_range),length(Fs_range));

% Number MC simulations
N_mc = 2;   
% N_mc = 20*50
run_settings = struct;
run_settings.compute_error = true;
run_settings.verbose = false;
run_settings.save_input = false;
run_settings.save_residuals = false;


for i_Fs = 1:length(Fs_range)
for i_rot = 1:length(f_rotation_range)
    
    fprintf('%s: i_rate = %d, i_rot = %d start\n', datestr(now,'HH:MM:SS.FFF'), i_Fs, i_rot)
        
    % Run
    Fs = Fs_range(i_Fs);
    Ts = 1/Fs;  % [s] Sampling period

    
    sig_cont_gyro_deg = 1/sqrt(500); % Gyro continous noise
    sig_cont_gyro = deg2rad(sig_cont_gyro_deg);
    sig_cont_acc = 0.5/sqrt(500);     % Acc continous noise
    
    sig_acc = sqrt(Fs)*sig_cont_acc;     % Discrete Acc noise
    sig_gyro = sqrt(Fs)*sig_cont_gyro;   % Discrete gyro noise
    rad2deg(sig_gyro)
    
    sig_pos = 1e-1;        % Sigma position update
    
    % estimate a constant bias
    sig_b_a = 0;
    sig_b_g = 0;
    sig_b_a_init = 0.2;          % From  Carlsson2021
    sig_b_g_init = deg2rad(1);   % From  Carlsson2021

    sig_init_R = deg2rad(1);
    sig_init_v = 0.1;
    
    
    N_periods = f_rotation_range(i_rot);
    
    
    time_factor = 5; % 50 seconds 

    T_end = 10*time_factor;  % [s]
    t = 0:Ts:T_end - Ts;
    N = length(t);
    
    
    F_pos = 100;
    assert(mod(Fs,F_pos) == 0)
    N_pos_update = Fs/F_pos;
    inds_pos_update = 1:N_pos_update:N;
        
    % Get 5 secs in samples
    inds_release = 1:length(0:Ts:5-Ts);    
    
    
    IN_length = 5; % 
    time_point_release = 40;
    
    % Sum of squared error
    % R, p, 
    sseArray1st = zeros(6, length(inds_release));
    sseArray2nd = zeros(6, length(inds_release));
    sseGyro2nd = zeros(6, length(inds_release));
    sseGyro1st = zeros(6, length(inds_release));
    
    r_true = [-0.0095    0.0032    0.0010
        -0.0095    0.0032   -0.0010
        -0.0095    0.0095    0.0010
        -0.0095    0.0095   -0.0010
        -0.0095   -0.0095    0.0010
        -0.0095   -0.0095   -0.0010
        -0.0095   -0.0032    0.0010
        -0.0095   -0.0032   -0.0010
        -0.0032    0.0032    0.0010
        -0.0032    0.0032   -0.0010
        -0.0032    0.0095    0.0010
        -0.0032    0.0095   -0.0010
        -0.0032   -0.0095    0.0010
        -0.0032   -0.0095   -0.0010
        -0.0032   -0.0032    0.0010
        -0.0032   -0.0032   -0.0010
        0.0032    0.0032    0.0010
        0.0032    0.0032   -0.0010
        0.0032    0.0095    0.0010
        0.0032    0.0095   -0.0010
        0.0032   -0.0095    0.0010
        0.0032   -0.0095   -0.0010
        0.0032   -0.0032    0.0010
        0.0032   -0.0032   -0.0010
        0.0095    0.0032    0.0010
        0.0095    0.0032   -0.0010
        0.0095    0.0095    0.0010
        0.0095    0.0095   -0.0010
        0.0095   -0.0095    0.0010
        0.0095   -0.0095   -0.0010
        0.0095   -0.0032    0.0010
        0.0095   -0.0032   -0.0010]';
    
    
    r_true = r_true - mean(r_true,2);
    A = compute_A_non_center(r_true);
    K = size(r_true,2);    

    Q_gyro = eye(3)*sig_gyro^2/K;
    Q_acc = eye(3*K)*sig_acc^2;
    Q_pos = sig_pos^2*eye(3);
    
    settings_default = struct;
    settings_default.save_full_covariances = false;
    settings_default.verbose = false;
    settings_default.T = Ts;
    settings_default.g = [0; 0; -9.81];
    settings_default.r = r_true;
    settings_default.Q_acc = Q_acc;
    settings_default.Q_bias_acc = sig_b_a^2*eye(3*K);
    settings_default.R_pos = Q_pos;
    settings_default.Q_bias_gyro = sig_b_g^2*eye(3)/K;
    settings_default.do_position_updates = true;
    settings_default.do_rotation_updates = false;
    
    simdata = struct;
    
    simdata.accelerometer_array_2nd_order = settings_default;
    simdata.accelerometer_array_2nd_order.propagate_position = true;
    simdata.accelerometer_array_2nd_order.propagate_velocity = true;
    simdata.accelerometer_array_2nd_order.propagate_bias_alpha = true;
    simdata.accelerometer_array_2nd_order.propagate_bias_gyro = true;
    simdata.accelerometer_array_2nd_order.set_T2_R_zero = false;
    simdata.accelerometer_array_2nd_order.get_model = @D_LG_EKF_Array_v4_alpha;
    simdata.accelerometer_array_2nd_order.do_gyro_updates = true;
    simdata.accelerometer_array_2nd_order.R_gyro = Q_gyro;
    simdata.accelerometer_array_2nd_order.label = "2nd order accelerometer array";
    
    
    simdata.accelerometer_array_1st_order = settings_default;
    simdata.accelerometer_array_1st_order.propagate_position = true;
    simdata.accelerometer_array_1st_order.propagate_velocity = true;
    simdata.accelerometer_array_1st_order.propagate_bias_alpha = true;
    simdata.accelerometer_array_1st_order.propagate_bias_gyro = true;
    simdata.accelerometer_array_1st_order.set_T2_R_zero = true;
    simdata.accelerometer_array_1st_order.get_model = @D_LG_EKF_Array_v4_alpha;
    simdata.accelerometer_array_1st_order.R_gyro = Q_gyro;
    simdata.accelerometer_array_1st_order.do_gyro_updates = true;
    simdata.accelerometer_array_1st_order.label = "1st order accelerometer array";
    
    simdata.gyroscope_2nd_order = settings_default;
    simdata.gyroscope_2nd_order.propagate_bias_gyro = true;
    simdata.gyroscope_2nd_order.input_accelerometers = true;
    simdata.gyroscope_2nd_order.propagate_position = true;
    simdata.gyroscope_2nd_order.propagate_velocity = true;
    simdata.gyroscope_2nd_order.propagate_bias_s = true;
    simdata.gyroscope_2nd_order.set_T2_R_zero = false;
    simdata.gyroscope_2nd_order.get_model = @D_LG_EKF_Gyro_2nd_v4;
    simdata.gyroscope_2nd_order.Q_gyro = Q_gyro;
    simdata.gyroscope_2nd_order.do_gyro_updates = false;
    simdata.gyroscope_2nd_order.label = "2nd order gyroscope";
    
    simdata.gyroscope_1st_order = settings_default;
    simdata.gyroscope_1st_order.input_accelerometers = true;
    simdata.gyroscope_1st_order.propagate_bias_s = true;
    simdata.gyroscope_1st_order.propagate_bias_gyro = true;
    simdata.gyroscope_1st_order.propagate_position = true;
    simdata.gyroscope_1st_order.propagate_velocity = true;
    simdata.gyroscope_1st_order.get_model = @D_LG_EKF_Gyro_1st_v4;
    simdata.gyroscope_1st_order.N_a = K;
    simdata.gyroscope_1st_order.Q_gyro = Q_gyro;
    simdata.gyroscope_1st_order.do_gyro_updates = false;
    simdata.gyroscope_1st_order.label = "1st order gyroscope";


    % Generate motion 
    % phi in [0, pi]
    inp = struct;
    inp.phi = "sinus";
    params = struct;
    params.A = pi/2;
    params.b = pi/2;
    params.f = (2 + N_periods)/T_end*time_factor; % Three periods
    inp.phi_params = params;
    
    % theta in [0, 2pi]
    inp.theta = "sinus";
    params = struct;
    params.A = pi;
    params.b = pi;
    params.f = (N_periods)/T_end*time_factor; % two periods
    inp.theta_params = params;
    
    m = get_spherical_motion(t, inp);
    vels = compute_omega(m);
    
    phi = m.phi;
    theta = m.theta;
    w_b = vels.w_b;
    w_dot_b = vels.w_dot_b;
    % ppm = ParforProgressbarText(N_mc);
    R_bn_true = R_bn_spherical(phi,theta);
    R_nb_true = pagectranspose(R_bn_true);
    
    f_pos = [1 2 3 ]/T_end*2*pi*time_factor;
    
    p_true = zeros(3,N);
    v_true = zeros(3,N);
    a_true = zeros(3,N);
    
    for i = 1:3
        f_i = f_pos(i);
        p_true(i,:) = sin(f_i*t);
        v_true(i,:) = f_i*cos(f_i*t);
        a_true(i,:) = -f_i^2*sin(f_i*t);
    end

    %
    K = size(r_true,2); % Number of acc triads
    inds = reshape(1:3*K,3,[]);
       
    % Generate the true measurements 
    
    % Zero acceleration, stay at the same position. Measure gravity in body frame
    % u_truc acc in sensor frame
    u_true_acc = zeros(3*K,N);
    rot_comp = zeros(3*K,N);
    trans_comp = zeros(3,N);
    
    for n = 1:N
        W = skew_sym(w_b(:,n))^2 + skew_sym(w_dot_b(:,n));
        trans_comp(:,n) = R_bn_true(:,:,n)*(a_true(:,n) - settings_default.g);
        for k = 1:K
            kk = inds(:,k);
            r_k = r_true(:,k);
            rot_comp(kk,n) = W*r_k;
            u_true_acc(kk,n) = trans_comp(:,n) + rot_comp(kk,n);
        end
    end
    
    % Gyroscopes measure angular velocity in body coordinates
    u_true_gyro = w_b;
    
    
    S_true = struct;
    S_true.R = R_nb_true; % Track transformation ns instead
    S_true.w = w_b;
    S_true.p = p_true;
    S_true.v = v_true;
    S_true.omega_dot = w_dot_b;
    S_true.v_dot = a_true;
    
 
    w_max_deg = rad2deg(max(abs(w_b),[],'all'));
    
    label_all = sprintf("$w_{max}$ = %.0f deg/s, Fs = %d", w_max_deg, Fs);
    
    sse_gyro_1st = zeros(6, length(inds_release));
    sse_gyro_2nd = zeros(6, length(inds_release));
    sse_array_1st = zeros(6, length(inds_release));
    sse_array_2nd = zeros(6, length(inds_release));
    
    tic
    parfor i_mc = 1:N_mc

                
        noise_acc = chol(Q_acc)*randn(3*K,N);
        noise_gyro = chol(Q_gyro)*randn(3,N);
        noise_pos = nan(3,N);
        noise_pos(:,inds_pos_update) = chol(Q_pos)*randn(3,length(inds_pos_update));
        
        b_a = sig_b_a_init*randn(3*K,1);
        b_g = sig_b_g_init*randn(3,1)/sqrt(K);
                
        sensorData = struct;

        sensorData.acc_measurements = u_true_acc + b_a + noise_acc;
        sensorData.gyro_measurements = u_true_gyro + b_g + noise_gyro;
        sensorData.position_measurements = p_true + noise_pos;
               
        
        init = struct;
        init.cov.R = eye(3)*sig_init_R^2;
        init.cov.p = Q_pos*2;
        init.cov.v = eye(3)*sig_init_v^2;
        init.cov.omega = Q_gyro*2;
        
        init.mean.R = R_nb_true(:,:,1)*expSO3(chol(init.cov.R)*randn(3,1));
        init.mean.p = p_true(:,1) + noise_pos(:,1);
        init.mean.v = v_true(:,1) + chol(init.cov.v)*randn(3,1);
        init.mean.omega = u_true_gyro(:,1) + noise_gyro(:,1);
        
        
        init.mean.b_a = zeros(3*K,1);
        init.cov.b_a = sig_b_a_init^2*eye(3*K)*3;
                
        init.mean.b_g = zeros(3,1);
        init.cov.b_g = eye(3)*sig_b_g_init^2/K*3;
        
        % between 10 and 15
        % assert that IN array is longer than
        release_time = 4.9 * rand + time_point_release;
        % release_time = 10;
        mask = t >= release_time;
        % Release after release_time s
        sensorData.position_measurements(:, mask) = nan;
            
        
        resSingle = struct;


        resSingle.label = "";
        [~,resSingle.accelerometer_array_2nd_order] = run_filter(sensorData, init, simdata.accelerometer_array_2nd_order, run_settings, S_true);
        [~,resSingle.accelerometer_array_1st_order] = run_filter(sensorData, init, simdata.accelerometer_array_1st_order, run_settings, S_true);
        [~,resSingle.gyroscope_2nd_order] = run_filter(sensorData, init, simdata.gyroscope_2nd_order,run_settings, S_true);
        [~,resSingle.gyroscope_1st_order] = run_filter(sensorData, init, simdata.gyroscope_1st_order,run_settings, S_true);
        
        err_a2 = resSingle.accelerometer_array_2nd_order.res.err.tot(:,mask);
        sse_array_2nd = sse_array_2nd + err_a2(:,inds_release).^2;
        
        err_a1 = resSingle.accelerometer_array_1st_order.res.err.tot(:,mask);
        sse_array_1st = sse_array_1st + err_a1(:,inds_release).^2;

        err_g2 = resSingle.gyroscope_2nd_order.res.err.tot(:,mask);
        sse_gyro_2nd = sse_gyro_2nd + err_g2(:,inds_release).^2;
        
        err_g1 = resSingle.gyroscope_1st_order.res.err.tot(:,mask);
        sse_gyro_1st = sse_gyro_1st + err_g1(:,inds_release).^2;
        
    end
    toc
    
    
    data = struct;
    data.gyro_1st = get_struct(sqrt(sse_gyro_1st./N_mc));
    data.gyro_1st.label = simdata.gyroscope_1st_order.label + newline + label_all;
    
    data.gyro_2nd = get_struct(sqrt(sse_gyro_2nd./N_mc));
    data.gyro_2nd.label = simdata.gyroscope_2nd_order.label + newline + label_all;
    
    data.array_1st = get_struct(sqrt(sse_array_1st./N_mc));
    data.array_1st.label = simdata.accelerometer_array_1st_order.label + newline + label_all;
    
    data.array_2nd = get_struct(sqrt(sse_array_2nd./N_mc));
    data.array_2nd.label = simdata.accelerometer_array_2nd_order.label + newline + label_all;
    
    data.time = (inds_release - 1) * Ts;
    
    data_tot{i_rot,i_Fs} = data;
    % delete(ppm);    
    fprintf('%s: k = %d end\n', datestr(now,'HH:MM:SS.FFF'), i_rot)
end
end

save(fullfile(pathData,"data.mat"));

%% Functions
% Execution
function [c, misc] = run_filter(sensorData, init, simdata, run_settings, S_ref, x, f_change, mask_logLL)

if nargin < 4
    run_settings = struct;
end

if isfield(run_settings, "verbose")
    simdata.verbose = run_settings.verbose;
end
if nargin > 5
    [sensorData, init, simdata, changes] = f_change(x, sensorData, init, simdata);
end
model = simdata.get_model(simdata);

res = DLGEKFv4(sensorData, init, model, simdata);

if isfield(run_settings, "compute_error") && nargin > 4
    res.err = compute_error_tot(res, S_ref);
end

misc = struct;
misc.res = res;
if isfield(run_settings, "save_input") && run_settings.save_input
    misc.sensorData = sensorData;
    misc.init = init;
    misc.simdata = simdata;
    misc.model = model;
end

if nargin > 5
    misc.changes = changes;
end

o = 0; % Offset in ind
% Depends on in the order of measurement updates in filter
save_residuals = isfield(run_settings, "save_residuals") && run_settings.save_residuals;

if isfield(sensorData, "gyro_measurements") && simdata.do_gyro_updates && save_residuals 
    mask = all(~isnan(sensorData.gyro_measurements));
    e = res.logL.residuals_normalized(mask);
    e_gyro = cellfun(@(e_i) e_i(1:3), e(2:end), 'UniformOutput', false); % Skip initial value
    misc.e_gyro = cat(2, e_gyro{:});
    o = o + 3;
end

if isfield(sensorData, "position_measurements") && simdata.do_position_updates && save_residuals
    inds = (1:3) + o;
    mask = all(~isnan(sensorData.position_measurements));
    e = misc.res.logL.residuals_normalized(mask);
    e_pos = cellfun(@(e_i) e_i(inds), e(2:end), 'UniformOutput', false); % Skip initial value
    misc.e_pos = cat(2, e_pos{:});
    o = o + 3;
end

if isfield(sensorData, "rotation_measurements") && simdata.do_rotation_updates && save_residuals
    inds = (1:3) + o;
    mask = reshape(all(~isnan(sensorData.rotation_measurements),[1 2]),[],1);
    e = misc.res.logL.residuals_normalized(mask);
    e_rot = cellfun(@(e_i) e_i(inds), e(2:end), 'UniformOutput', false); % Skip initial value
    misc.e_rot = cat(2, e_rot{:});
end

use_mask_logLL = isfield(run_settings, "use_mask_logLL") && run_settings.use_mask_logLL;
if nargin > 7 && use_mask_logLL
    % Assume first time point is included
    parts = res.logL.parts(mask_logLL);
    % Skip first time-point
    logL = -1/2*sum(parts(2:end));
    c = -logL;
else
    c = -res.logL.value;
end

end

function err = compute_error_tot(S_tot, S_ref)

err = struct;
err.mean = compute_error(S_tot.filt.mean, S_ref);

% Copy standard deviations
fields = fieldnames(err.mean);
for idx = 1:length(fields)
    err.std.(fields{idx}) = S_tot.filt.std.(fields{idx});
end
err.tot = [err.mean.R;err.mean.p];
end
%% 
% 

function data = get_struct(sse)

    data = struct;
    data.R = sse(1:3,:);
    data.p = sse(4:6,:);

end
