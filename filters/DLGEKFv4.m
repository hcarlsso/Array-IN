 function res = DLGEKFv4(sensorData, init, model, settings)
%D-LG-EKF-ARRAY Summary of this function goes here
% State vector 
% R;          % Rotation between body frame and navigation frame
% x(1:3);     % angular velocity in body frame
% x(4:6);     % position in navigation frame
% x(7:9);     % velocity in navigation frame
% Covariance matrix
% P(1:3)        % Rotation 
% P(4:6);       % angular velocity in body frame
% P(7:9);       % position in navigation frame
% P(10:12);     % velocity in navigation frame
% dbstop if error
    if isfield(settings, "verbose")
        verbose = settings.verbose;
    else
        verbose = false;
    end
    
    if verbose
        fprintf("Run Discrete Lie-Group EKF Inertial Navigation v4\n")
    end
    
    % -------------------------------------------------------------------------
    % These must exists
    u_prop = model.get_input(sensorData);
    Q_prop = model.get_Q();
    Nt =  size(u_prop,2);

    if verbose
        fprintf("Number of time-sample: %d\n", Nt)
        fprintf("Size of input vector: %d\n", size(u_prop,1))
    end
     
    % -------------------------------------------------------------------------
    % Kalman updates using gyroscopes
    if isfield(settings, "do_gyro_updates")
        do_gyro_updates = settings.do_gyro_updates;
    else
        do_gyro_updates = true;
    end
    if isfield(sensorData, "gyro_measurements") && do_gyro_updates
        u_g = sensorData.gyro_measurements;
        assert(all(size(u_g) == [3,Nt]));
    else
        u_g = nan(3,Nt);
    end
    if verbose
        fprintf("Number of gyroscope updates: %d\n", sum(~isnan(u_g(1,:))))
    end
    
    % -------------------------------------------------------------------------
    if isfield(settings, "do_position_updates")
        do_position_updates = settings.do_position_updates;
    else
        do_position_updates = true;
    end
    if isfield(sensorData, "position_measurements") && do_position_updates
        p_obs = sensorData.position_measurements;
        assert(size(p_obs,1) == 3)
        assert(size(p_obs,2) == Nt)        
    else
        p_obs = nan(3,Nt);
    end
    if verbose
        fprintf("Number of position updates: %d\n", sum(~isnan(p_obs(1,:))))
    end
    
    % -------------------------------------------------------------------------
    if isfield(settings, "do_rotation_updates")
        do_rotation_updates = settings.do_rotation_updates;
    else
        do_rotation_updates = true;
    end
    if isfield(sensorData, "rotation_measurements") && do_rotation_updates
        R_obs = sensorData.rotation_measurements;
        assert(size(R_obs,1) == 3)
        assert(size(R_obs,3) == Nt)
    else
        R_obs = nan(3,3,Nt);
    end
    if verbose
        fprintf("Number of rotation updates: %d\n", sum(~isnan(R_obs(1,1,:))))
    end    
    % -------------------------------------------------------------------------
    if isfield(sensorData, "zero_velocity_updates")
        zupts = sensorData.zero_velocity_updates;
    else
        zupts = nan(3,Nt);
    end
    if verbose
        fprintf("Number of ZUPTs: %d\n", sum(~isnan(zupts(1,:))))
    end    
    
    % -------------------------------------------------------------------------
    if isfield(settings, "save_full_covariances")
        save_full_covariances = settings.save_full_covariances;        
    else
        save_full_covariances = false;
    end    
    if verbose
        fprintf("Save full covariances: %d\n", save_full_covariances)
    end
    % -------------------------------------------------------------------------
    if isfield(settings, "save_pred")
        save_pred = settings.save_pred;        
    else
        save_pred = false;
    end    
    if verbose
        fprintf("Save prediction: %d\n", save_pred)
    end
    % -------------------------------------------------------------------------
    if isfield(settings, "save_aux_vars")
        save_aux_vars = settings.save_aux_vars;        
    else
        save_aux_vars = false;
    end    
    if verbose
        fprintf("Save auxillary variables: %d\n", save_aux_vars)
    end
    
    % -------------------------------------------------------------------------
    if isfield(settings, "save_jacobians")
        save_jacobians = settings.save_jacobians;        
    else
        save_jacobians = false;
    end    
    if verbose
        fprintf("Save jacobians: %d\n", save_jacobians)
    end
            
    
    % -------------------------------------------------------------------------
    Nx = model.Nx;
    Nw = model.Nw;
    
    if verbose
        fprintf("Size Nx: %d\n", Nx)
        fprintf("Size Nw: %d\n", Nw)
    end
    
    % Initial aposteriori state
    initOut = model.get_initial_conditions(init);
    R0 = initOut.R0;
    x0 = initOut.x0;
    P0 = initOut.P0;
    
    assert(size(x0,1) == Nx - 3)
    assert(all(size(P0) == [Nx,Nx]))
    
    % Three in Rotation matrix as well        
    % n|n-1
    R_pred = nan(3,3, Nt);
    x_pred = nan(Nx-3, Nt); % Reduce by 3 for rotation
    if save_full_covariances
        P_pred = nan(Nx, Nx, Nt);
    end
    std_pred_diag = nan(Nx, Nt);

    % n|n
    R_filt = zeros(3,3,Nt);
    x_filt = zeros(Nx-3, Nt); % Reduce by 3 for rotation
    if save_full_covariances
        P_filt = zeros(Nx, Nx, Nt);
    end
    std_filt_diag = zeros(Nx, Nt);
    
    % accelerations    
    omega_dot = nan(3, Nt);
    v_dot = nan(3,Nt);
    s = nan(3,Nt);
    
    % set initial values
    R_filt(:,:,1) = R0;
    x_filt(:,1) = x0;    
    if save_full_covariances
        P_filt(:,:,1) = P0;
    end
    std_filt_diag(:,1) = sqrt(diag(P0));
    
    % Basic Checks
    assert(~is_any_nan(R0));
    assert(~is_any_nan(x0));
    assert(~is_any_nan(P0));
    
    % mise a jour
    R_maj = R0;
    x_maj = x0;
    P_maj = P0;
    
    % Variables storage 
    logLL = nan(Nt,1);
    residuals_normalized = cell(Nt,1);
    
    if save_jacobians
        K_tot = cell(Nt,1);
        F_tot = cell(Nt,1);
        G_tot = cell(Nt,1);
        F_pre_tot = cell(Nt,1);
        G_pre_tot = cell(Nt,1);
    end
    
    
    if verbose
        S0 = struct;
        S0.R = initOut.R0;
        S0.x = initOut.x0;
        S0.std = sqrt(diag(initOut.P0));
        S_init = model.extract_variables(S0);
        model.print_info(S_init, sensorData, settings);
    end

    % Functions
    if verbose && any(~isnan(u_g),'all')
        fprintf("Do Kalman updates using gyroscopes\n")
        fprintf("\tStart of gyroscope triad measurements as updates:\n")
        fprintf("\t%10.1f %10.1f %10.1f\n", rad2deg(u_g(1:3,1:3))')
    end

    if verbose && any(~isnan(p_obs),'all')
        fprintf("Do Kalman updates using positions\n")
        fprintf("\tStart of position updates:\n")
        fprintf("\t%10.1f %10.1f %10.1f\n", (p_obs(1:3,1:3))')
    end
    if verbose && any(~isnan(R_obs),'all')
        fprintf("Do Kalman updates using rotations\n")
        fprintf("\t%10.1f %10.1f %10.1f\n", R_obs(:,:,1)')
    end
    
    if verbose && any(~isnan(zupts),'all')
        fprintf("Do Kalman updates using ZUPTs\n")
    end
    
    w = zeros(Nw, 1); % Just set to zero
    for n = 2:Nt
        if isfield(settings, 'progress')
            settings.progress(n,Nt)
        end
        % Propagation
        % get n-1 values. 
        u_n = u_prop(:,n-1); 
                
        
        resProp = model.propagate(R_maj, x_maj, u_n, w);
        Omega_n = resProp.Omega;
        dOmega_de_n = resProp.dOmega_de;
        dOmega_dw_n = resProp.dOmega_dw;
        
        if save_jacobians
            F_pre_tot{n} = dOmega_de_n;
            G_pre_tot{n} = dOmega_dw_n;
        end
        
        % Accelerations occur at n-1
        if isfield(resProp,"omega_dot")
            omega_dot(:,n-1) = resProp.omega_dot;
        end
        if isfield(resProp,"v_dot")
            v_dot(:,n-1) = resProp.v_dot;
        end
        if isfield(resProp,"s")
            s(:,n-1) = resProp.s;
        end

        
        % Mean propagation
        % n|n-1
        R_prop = R_maj*expSO3(Omega_n(1:3)); % SO(3)
        x_prop = x_maj + Omega_n(4:end); %Euclidean
        
        % Covariance propagation
        Ad = eye(size(P_maj)); % adjoint
        Ad(1:3,1:3) = AdSO3(expSO3(-Omega_n(1:3)));
        Phi_n = eye(size(P_maj));
        Phi_n(1:3,1:3) = PhiSO3(-Omega_n(1:3));
        
        F_n = Ad + Phi_n * dOmega_de_n;
        G_n = Phi_n *dOmega_dw_n;
        P_prop = F_n * P_maj *F_n' + G_n*Q_prop*G_n';
        
        % Store values n|n-1
        if save_jacobians
            F_tot{n} = F_n;
            G_tot{n} = G_n;
        end
        
        % Basic Checks
        assert(~is_any_nan(R_prop));
        assert(~is_any_nan(x_prop));
        assert(~is_any_nan(P_prop));
        
        % Measurement update
        % n|n
        Hs = cell(4,1);
        es = cell(4,1);
        Rs = cell(4,1);
        i = 0;
        if ~isnan(u_g(1,n))
            i = i + 1;
            [es{i}, Hs{i}, Rs{i}] = model.gyroscope_update(u_g(:,n), R_prop, x_prop);
        end
        if ~isnan(p_obs(1,n))
            i = i + 1;
            [es{i}, Hs{i}, Rs{i}] = model.position_update(p_obs(:,n), R_prop, x_prop);
        end
        if ~isnan(R_obs(1,1,n))
            i = i + 1;
            [es{i}, Hs{i}, Rs{i}] = model.rotation_update(R_obs(:,:,n), R_prop, x_prop);
        end
        if ~isnan(zupts(1,n))
            i = i + 1;
            [es{i}, Hs{i}, Rs{i}] = model.zero_velocity_update(zupts(:,n), R_prop, x_prop);
        end
        
        if i > 0
            H_update = cat(1, Hs{1:i});
            e_update = cat(1, es{1:i});
            R_update = blkdiag(Rs{1:i});
            
            % Innovations and likelihood
            S = H_update*P_prop*H_update' + R_update;
            try
                L = chol(S, 'lower');
            catch ME
                disp(n)
                rethrow(ME)
            end
            e_norm = L\e_update;
            logdetS = 2*sum(log(diag(L)));
            logLL(n) = dot(e_norm,e_norm) + logdetS;
            residuals_normalized{n} = e_norm;
            
            % Kalman update
            % K = (P_prop*H_update')/S;
            A = (P_prop*H_update')/(L');
            K = A/L;
            m = K*e_update;
            
            % mean
            R_maj = R_prop*expSO3(m(1:3)); % SO(3)
            x_maj = x_prop + m(4:end);
            
            %Covariance
            Phi_maj = eye(size(P_prop));
            Phi_maj(1:3,1:3) = PhiSO3(-m(1:3));
            I_KH = eye(Nx) - K*H_update;
            P_maj = Phi_maj*(I_KH * P_prop *I_KH' + K*R_update*K')*Phi_maj';
            
            if save_jacobians
                K_tot{n} = K;
            end
        else
            % No Kalman updates
            R_maj = R_prop;
            x_maj = x_prop;
            P_maj = P_prop;
        end
        assert(~is_any_nan(R_maj));
        assert(~is_any_nan(x_maj));
        assert(~is_any_nan(P_maj));
        
        % Store values n|n-1
        R_pred(:,:,n) = R_prop;
        x_pred(:,n) = x_prop;
        if save_full_covariances
            P_pred(:,:,n) = P_prop;
        end
        std_pred_diag(:,n) = sqrt(diag(P_prop));
        
        % Store values n|n
        R_filt(:,:,n) = R_maj;
        x_filt(:,n) = x_maj;
        if save_full_covariances
            P_filt(:,:,n) = P_maj;
        end
        std_filt_diag(:,n) = sqrt(diag(P_maj));

    end
    
    % Extract variables
    Sfilt = struct;
    Sfilt.R = R_filt;
    Sfilt.x = x_filt;
    Sfilt.std = std_filt_diag;
    if save_full_covariances
        Sfilt.P = P_filt;
    end
    
    if save_jacobians
        Sfilt.K = K_tot;
    end
    
    Sprop = struct;
    Sprop.R = R_pred;
    Sprop.x = x_pred;
    Sprop.std = std_pred_diag;
    if save_full_covariances
        Sprop.P = P_pred;
    end
        
    if save_jacobians
        Sprop.F = F_tot;
        Sprop.G = G_tot;
        Sprop.F_pre = F_pre_tot;
        Sprop.G_pre = G_pre_tot;
    end
    
    res = struct;
    res.filt = model.extract_variables(Sfilt);
    
    if save_pred
        res.pred = model.extract_variables(Sprop);
    end
    
    if save_aux_vars
        aux = struct;        
        aux.omega_dot = omega_dot;
        aux.v_dot = v_dot;
        aux.s = s;
        res.aux = aux;
    end
    
    res.logL.value = -1/2*sum(logLL(~isnan(logLL)));
    res.logL.parts = logLL;
    res.logL.residuals_normalized = residuals_normalized;
    if save_full_covariances
        res.tot.filt = Sfilt;
        res.tot.pred = Sprop;
    end
    if isfield(settings,"label")
        res.label = settings.label;
    end
end

