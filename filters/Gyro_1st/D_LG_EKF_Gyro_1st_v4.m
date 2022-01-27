classdef D_LG_EKF_Gyro_1st_v4
    %D_LG_EKF_CLASSIC Summary of this class goes here
    %   Detailed explanation goes here
%  alpha = [omega_dot; s]
    properties
        T                       % Sampling time 
        g                       % gravity in navigation frame
        inds_R = 1:3            % Rotation matrix R_nb, from body to navigation frame
        inds_p = []             % Position in navigation frame
        inds_v = []             % Velocity in navigation frame        
        inds_b_g = []           % Bias in gyroscope 
        inds_b_s = []           % Bias in specific force
        inds_w_g = 1:3          % white noise gyro
        inds_w_s = []       % alpha white noise
        inds_w_b_g = []         % Process noise bias gyroscope
        inds_w_b_s = []         % Process noise bias specific force        
        inds_y_g = 1:3
        inds_y_a = []
        Nx
        Nw
        Ny
        N_a
        A
        A_omega_dot
        A_s
        r
        T2_R
        Q
        R_pos
        R_rot
    end    
    methods
        function obj = D_LG_EKF_Gyro_1st_v4(settings)
            %D_LG_EKF_CLASSIC Construct an instance of this class
            %   Detailed explanation goes here
            % Assume one gyro
            
            obj.T = settings.T;
            obj.g = settings.g;
            
            % R, p, v, omega
            Nx = 3; % Rotation
            Nw = 3;
            Ny = 3;
            if isfield(settings,"propagate_bias_gyro") && settings.propagate_bias_gyro
                obj.inds_b_g = (1:3) + Nx;                
                Nx = Nx + 3;
                
                obj.inds_w_b_g = (1:3) + Nw;
                Nw = Nw + 3;
            end
            if isfield(settings,"input_accelerometers") && ~settings.input_accelerometers
                
            else
                if isfield(settings,"N_a")
                    obj.N_a = settings.N_a;
                    obj.A_s = repmat(eye(3), 1, obj.N_a)/obj.N_a;
                else
                    error("N_a")
                end
                
                obj.inds_y_a = (1:3*obj.N_a) + Ny;
                Ny = Ny + 3*obj.N_a;
                
                obj.inds_w_s = (1:3) + Nw;
                Nw = Nw + 3;
                
                if isfield(settings,"propagate_position") && settings.propagate_position
                    obj.inds_p = (1:3) + Nx;
                    Nx = Nx + 3;
                end
                if isfield(settings,"propagate_velocity") && settings.propagate_velocity
                    obj.inds_v = (1:3) + Nx;
                    Nx = Nx + 3;
                end
                
                if isfield(settings,"propagate_bias_s") && settings.propagate_bias_s
                    obj.inds_b_s = (1:3) + Nx;
                    Nx = Nx + 3;
                    
                    obj.inds_w_b_s = (1:3) + Nw;                    
                    Nw = Nw + 3;
                end
            end

            
            obj.Nx = Nx;
            obj.Nw = Nw;
            obj.Ny = Ny;

            
            % -------------------------------------------------------------
            % Fill Q
            % -------------------------------------------------------------
            Q = zeros(Nw,Nw);
            Q(obj.inds_w_g, obj.inds_w_g) = settings.Q_gyro;
            
            if ~isempty(obj.inds_w_b_g)
                Q(obj.inds_w_b_g,obj.inds_w_b_g) = settings.Q_bias_gyro;
            end
            
            if ~isempty(obj.inds_w_s)
                if isfield(settings,"Q_s")
                    Q(obj.inds_w_s, obj.inds_w_s) = settings.Q_s;
                elseif isfield(settings,"Q_acc")
                    Q(obj.inds_w_s, obj.inds_w_s) = obj.A_s*settings.Q_acc*obj.A_s';
                else
                    error("No covariance for s")
                end
            end

            if ~isempty(obj.inds_w_b_s) 
                if isfield(settings,"Q_bias_s")
                    Q(obj.inds_w_b_s, obj.inds_w_b_s) = settings.Q_bias_s;
                elseif isfield(settings,"Q_bias_acc")
                    Q(obj.inds_w_b_s, obj.inds_w_b_s) = obj.A_s*settings.Q_bias_acc*obj.A_s';
                else
                    error("No covariance for bias s")
                end
            end
            
            obj.Q = Q;
            
            % -----------------------------------------------------------------
            % Update covariance
            % -----------------------------------------------------------------
           
            if isfield(settings,"R_pos")
                obj.R_pos = settings.R_pos;
                assert(issymmetric(obj.R_pos))
                assert(all(size(obj.R_pos) == [3,3]))
            end
            if isfield(settings,"R_rot")
                obj.R_rot = settings.R_rot;
                assert(issymmetric(obj.R_rot))
                assert(all(size(obj.R_rot) == [3,3]))
            end
        end        
        function u = get_input(obj, sensorData)
            assert(size(sensorData.gyro_measurements,1) == 3)
            if ~isempty(obj.inds_y_a)
                assert(size(sensorData.acc_measurements,1) == 3*obj.N_a);
                u = [sensorData.gyro_measurements; sensorData.acc_measurements];
            else
                u = sensorData.gyro_measurements;                
            end
        end
        function Q = get_Q(obj)
            Q = obj.Q;         
        end
        function res = propagate(obj, R, x, y, w)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
                            
            assert(length(x) == obj.Nx - 3);
            assert(length(y) == obj.Ny);
            assert(length(w) == obj.Nw);            
            
            if ~isempty(obj.inds_v)
                v = x(obj.inds_v-3);             % velocity
            end
            
            if ~isempty(obj.inds_b_s)
                b_s = x(obj.inds_b_s - 3);   
            else
                b_s = zeros(3,1);
            end
            
            if ~isempty(obj.inds_b_g)
                b_g = x(obj.inds_b_g - 3);   
            else
                b_g = zeros(3,1);
            end
            
            % Process noise
            w_g = w(obj.inds_w_g);     % alpha
            if ~isempty(obj.inds_w_s)
                w_s = w(obj.inds_w_s);
            else
                w_s = zeros(3,1);
            end
                
            if ~isempty(obj.inds_w_b_s)
                w_b_s = w(obj.inds_w_b_s);   
            else
                w_b_s = zeros(3,1);   
            end
                        
            if ~isempty(obj.inds_w_b_g)
                w_b_g = w(obj.inds_w_b_g);   % white noise bias process
            else
                w_b_g = zeros(3,1);   
            end            

            y_g = y(obj.inds_y_g);
            omega = y_g - b_g - w_g;
            
            if ~isempty(obj.inds_y_a)
                y_a = y(obj.inds_y_a);
                y_a_mean = mean(reshape(y_a,3,[]),2);
                s = y_a_mean + b_s + w_s;   % Specific force
                v_dot = obj.g + R*s;        % Navigation acceleration
                
            else
                s = zeros(3,1);
                v_dot = zeros(3,1);
            end
            
            Omega = zeros(obj.Nx,1);
            % R
            Omega(obj.inds_R) = omega*obj.T;

            % p
            if ~isempty(obj.inds_p)
                Omega(obj.inds_p) = v*obj.T + v_dot*obj.T^2/2;
            end
            % v
            if ~isempty(obj.inds_v)
                Omega(obj.inds_v) = v_dot*obj.T;
            end
            
            if ~isempty(obj.inds_b_g)
                Omega(obj.inds_b_g) = w_b_g;
            end
            
            if ~isempty(obj.inds_b_s)
                Omega(obj.inds_b_s) = w_b_s;
            end
                        
            % -----------------------------------------------------------------
            % Jacobian in x
            % Fill Jacobian
            dOmega_de = zeros(obj.Nx, obj.Nx);
            
            if ~isempty(obj.inds_y_a)            
                d_v_dot_d_R = -R*HatSO3(s);
                d_v_dot_d_b_s = R;
            else
                d_v_dot_d_R = zeros(3,3);
                d_v_dot_d_b_s = zeros(3,3);
            end
                        
            % -----------------------------------------------------------------
            % R equation
            if ~isempty(obj.inds_b_g)
                d_omega_d_b_g = -eye(3);
                dOmega_de(obj.inds_R, obj.inds_b_g) = d_omega_d_b_g*obj.T;
            end
            
            % nothing in p
            % nothing in v
                                        
            % -----------------------------------------------------------------
            % p equation
            if ~isempty(obj.inds_p)
                dOmega_de(obj.inds_p,obj.inds_R) = d_v_dot_d_R*obj.T^2/2;             % R
                
                if ~isempty(obj.inds_v)
                    dOmega_de(obj.inds_p,obj.inds_v) = eye(3)*obj.T;                  % v
                end
                if ~isempty(obj.inds_b_s)
                    dOmega_de(obj.inds_p,obj.inds_b_s) = d_v_dot_d_b_s*obj.T^2/2; % b_s
                end
            end

            % -----------------------------------------------------------------
            % v equation
            if ~isempty(obj.inds_v)
                dOmega_de(obj.inds_v, obj.inds_R) = d_v_dot_d_R*obj.T;          % R
                
                if ~isempty(obj.inds_b_s)
                    dOmega_de(obj.inds_v,obj.inds_b_s) = d_v_dot_d_b_s*obj.T;         % b_s
                end
            end
            
            % -----------------------------------------------------------------
            % Jacobian in w            

            dOmega_dw = zeros(obj.Nx, obj.Nw);
                        
            d_v_dot_d_w_s = R;
            
            % -----------------------------------------------------------------------------
            % R equation
            d_omega_d_w_g = -eye(3);
            
            dOmega_dw(obj.inds_R, obj.inds_w_g) = d_omega_d_w_g*obj.T;
                        
            % nothing in w_b_s
            % nothing in w_b_g
            
            % -----------------------------------------------------------------------------
            % p equation
            if ~isempty(obj.inds_p)
                dOmega_dw(obj.inds_p, obj.inds_w_s) = d_v_dot_d_w_s*obj.T^2/2;  % w_s                                
            end
            % nothing in w_b_s
            % nothing in w_b_g
            
            % -----------------------------------------------------------------------------
            % v equation
            if ~isempty(obj.inds_v)                
                dOmega_dw(obj.inds_v, obj.inds_w_s) = d_v_dot_d_w_s*obj.T;      % w_s
            end
            
            
            % nothing in w_b_s
            % nothing in w_b_g
            
            % -----------------------------------------------------------------------------
            % b_s equation
            
            if ~isempty(obj.inds_b_s)
                dOmega_dw(obj.inds_b_s, obj.inds_w_b_s) = eye(3);
            end
            
            if ~isempty(obj.inds_b_g)
                dOmega_dw(obj.inds_b_g,obj.inds_w_b_g) = eye(3);
            end            
            
            res = struct;
            res.Omega = Omega;
            res.dOmega_de = dOmega_de;
            res.dOmega_dw = dOmega_dw;
            res.v_dot = v_dot;
            res.s = s;
        end
        function [e,H,Q] = position_update(obj, p_obs, ~, x_in)
            
            assert(~isempty(obj.R_pos))
            Q = obj.R_pos;
            
            H = zeros(3, obj.Nx);
            H(:,obj.inds_p) = eye(3); % p
                        
            
            p_pred = x_in(obj.inds_p-3);
            e =  p_obs - p_pred;
        end
        function [e,H,Q] = rotation_update(obj, R_obs, R_pred, ~)
       
            assert(~isempty(obj.R_rot))
            Q = obj.R_rot;
            
            % H rotation
            H = zeros(3, obj.Nx);
            H(:,1:3) = eye(3); % R    

            e = logSO3(invSO3(R_pred)*R_obs);
        end
        function initOut = get_initial_conditions(obj, initIn)
            
            
            initOut = struct;
            use_full = (isfield(initIn,"x") || isfield(initIn,"P") || isfield(initIn,"R"));
            use_partial = (isfield(initIn,"mean") || isfield(initIn,"cov"));
            if use_full && use_partial
                error("Both (R0,x0,P0) and (mean,cov) defined, use only one")
            elseif isfield(initIn,"x") && isfield(initIn,"P")
                initOut.R0 = initIn.R;
                initOut.x0 = initIn.x;
                initOut.P0 = initIn.P;
            elseif isfield(initIn,"mean") && isfield(initIn,"cov")
                m = initIn.mean;
                
                assert(all(size(m.R) == [3,3]));
                initOut.R0 = m.R;
                x0 = zeros(obj.Nx-3,1);
                
                if ~isempty(obj.inds_p)
                    x0(obj.inds_p - 3) = m.p;
                end
                
                if ~isempty(obj.inds_v)
                    x0(obj.inds_v - 3) = m.v;
                end
                                
                if ~isempty(obj.inds_b_s)
                    if isfield(m,"b_s")
                        x0(obj.inds_b_s - 3) = m.b_s;
                    elseif isfield(m,"b_a")
                        x0(obj.inds_b_s - 3) = -obj.A_s*m.b_a;
                    else
                        error("No mean value alpha bias")
                    end
                end

                initOut.x0 = x0;
                
                c = initIn.cov;
                P0 = zeros(obj.Nx, obj.Nx);
                P0(obj.inds_R, obj.inds_R) = c.R;
                
                if ~isempty(obj.inds_p)
                    P0(obj.inds_p, obj.inds_p) = c.p;
                end
                if ~isempty(obj.inds_v)
                    P0(obj.inds_v, obj.inds_v) = c.v;
                end
                if ~isempty(obj.inds_b_g)
                    P0(obj.inds_b_g, obj.inds_b_g) = c.b_g;
                end
                if ~isempty(obj.inds_b_s)
                    if isfield(m,"b_s")
                        P0(obj.inds_b_s, obj.inds_b_s) = c.b_s;
                    elseif isfield(m,"b_a")
                        P0(obj.inds_b_s, obj.inds_b_s) = obj.A_s*c.b_a*obj.A_s';
                    else
                        error("No cov value alpha bias")
                    end
                end
                
                initOut.P0 = P0;
            else
                error("No initial conditions")
            end
        end
        function Sout = extract_variables(obj,Sin)
            Sout = struct;
            Sout.mean.R = Sin.R;
            
            if ~isempty(obj.inds_p)
                Sout.mean.p = Sin.x(obj.inds_p - 3, :);
            end
            if ~isempty(obj.inds_v)
                Sout.mean.v = Sin.x(obj.inds_v - 3, :);
            end                        
            if ~isempty(obj.inds_b_g)
                Sout.mean.b_g = Sin.x(obj.inds_b_g - 3, :);
            end
            if ~isempty(obj.inds_b_s)
                Sout.mean.b_s = Sin.x(obj.inds_b_s - 3, :);
            end            
            
            Sout.std.R = Sin.std(obj.inds_R, :);
            
            if ~isempty(obj.inds_p)
                Sout.std.p = Sin.std(obj.inds_p, :);
            end
            if ~isempty(obj.inds_v)
                Sout.std.v = Sin.std(obj.inds_v, :);
            end
            
            if ~isempty(obj.inds_b_g)
                Sout.std.b_g = Sin.std(obj.inds_b_g, :);
            end
            if ~isempty(obj.inds_b_s)
                Sout.std.b_s = Sin.std(obj.inds_b_s, :);
            end            
                     
        end
        function print_info(obj, S_init, SensorData, settings)
            
            fprintf("Sampling time: %.2e [s]\n", settings.T)
            fprintf("Sampling freq: %.1f [Hz]\n", 1/settings.T)
            fprintf("T2 for rotation: %.1e [s]\n", obj.T2_R)
            fprintf("Propagate rotation: %d\n", ~isempty(obj.inds_R))
            fprintf("Propagate position: %d\n", ~isempty(obj.inds_p))
            fprintf("Propagate velocity: %d\n", ~isempty(obj.inds_v))
            fprintf("Propagate bias gyro: %d\n", ~isempty(obj.inds_b_g))
            fprintf("Propagate bias specific force: %d\n", ~isempty(obj.inds_b_s))

            %------------------------------------------------------------------            
            fprintf("Propagation data:\n")
            fprintf("\tAccelerometer data:\n")
            if ~isempty(obj.inds_w_s)
                try
                    Q_sqrt = chol(obj.Q(obj.inds_w_s, obj.inds_w_s));
                    fprintf("\t\twhite noise chol(Q_s) [m/s^2]\n")
                    fprintf("\t\t%10.1e%10.1e%10.1e\n", Q_sqrt')
                catch
                    Q_s = (obj.Q(obj.inds_w_s, obj.inds_w_s));
                    fprintf("\t\twhite noise Q_s [m/s^2]^2\n")
                    fprintf("\t\t%10.1e%10.1e%10.1e\n", Q_s')
                end
            end
            if ~isempty(obj.inds_b_s)
                try
                    Q_b_s_sqrt = chol(obj.Q(obj.inds_w_b_s, obj.inds_w_b_s));
                    fprintf("\t\tbias specific force: [m/s^2]\n")
                    fprintf("\t\t%10.1e%10.1e%10.1e\n", Q_b_s_sqrt')
                    fprintf("\t\t[m/s^2]\n")
                catch
                    Q_b_s = obj.Q(obj.inds_w_b_s, obj.inds_w_b_s);
                    fprintf("\t\tbias specific force: [m/s^2]^2\n")
                    fprintf("\t\t%10.1e%10.1e%10.1e\n", Q_b_s')
                    fprintf("\t\t[m/s^2]^2\n")

                end   
            end
            
            
            if isfield(settings,"constant_b_s")
                fprintf("\t\tConstant b_s:          [")
                fprintf("%.1e ", settings.constant_b_s)
                fprintf("] []\n")
            end
            
            fprintf("\t\tStart of accelerometer triad measurements:\n")
            fprintf("\t\t%10.1f %10.1f %10.1f\n", SensorData.acc_measurements(1:3,1:3)')
            
            if ~isempty(obj.r)
                fprintf("\t\tStart of accelerometer positions:\n")
                try
                    fprintf("\t\t%10.1e %10.1e %10.1e\n", obj.r(1:3,1:3)')
                catch
                    
                end
                fprintf("\t\tMean accelerometer positions: [")
                fprintf("%.1e ", mean(obj.r,2))
                fprintf("] [m]\n")
            end
            fprintf("\tGyroscope data:\n")
            if ~isempty(obj.inds_w_g)
                fprintf("\t\tgyro noise: [deg/s]\n")
                fprintf("\t\t%10.1e%10.1e%10.1e\n", rad2deg(chol(obj.Q(obj.inds_w_g, obj.inds_w_g)))')
                fprintf("\t\t[deg/s]\n")
            end
            if ~isempty(obj.inds_w_b_g)
                try
                    Q_sqrt = rad2deg(chol(obj.Q(obj.inds_w_b_g, obj.inds_w_b_g)));
                    fprintf("\t\tbias gyro noise: [deg/s]\n")
                    fprintf("\t\t%10.1e%10.1e%10.1e\n", Q_sqrt')
                    fprintf("\t\t[deg/s]\n")
                catch
                    Q_b_g = rad2deg(rad2deg(obj.Q(obj.inds_w_b_g, obj.inds_w_b_g)));
                    fprintf("\t\tbias gyro noise: [deg/s]^2\n")
                    fprintf("\t\t%10.1e%10.1e%10.1e\n", Q_b_g')
                    fprintf("\t\t[deg/s]^2\n")

                end
            end
 
            fprintf("Initial conditions:\n")
            fprintf("\tMean:\n")
            e_deg = rad2deg(my_rotm2eul(S_init.mean.R));
            fprintf("\t\tRotation: roll: %.1f, pitch: %.1f, yaw: %.1f [deg]\n", e_deg(1), e_deg(2), e_deg(3))
            
            if ~isempty(obj.inds_p)
                fprintf("\t\tPosition:          [")
                fprintf("%.1f ", (S_init.mean.p))
                fprintf("] [m]\n")
            end
            
            if ~isempty(obj.inds_v)
                fprintf("\t\tVelocity:          [")
                fprintf("%.1f ", (S_init.mean.v))
                fprintf("] [m/s]\n")
            end
                       
            if ~isempty(obj.inds_b_s)
                fprintf("\t\tBias s:        [")
                fprintf("%.1f ", (S_init.mean.b_s))
                fprintf("] [m/s^2]\n")
            end
            
            if ~isempty(obj.inds_b_g)
                fprintf("\t\tBias gyro:        [")
                fprintf("%.1f ", rad2deg(S_init.mean.b_g))
                fprintf("] [deg/s]\n")
            end
            
            fprintf("\tStd:\n")
            
            fprintf("\t\tRotation:          [")
            fprintf("%.1f ", rad2deg(S_init.std.R))
            fprintf("] [deg]\n")
            
            if ~isempty(obj.inds_p)
                fprintf("\t\tPosition:          [")
                fprintf("%.1f ", (S_init.std.p))
                fprintf("] [m]\n")
            end
            if ~isempty(obj.inds_v)
                fprintf("\t\tVelocity:          [")
                fprintf("%.1f ", (S_init.std.v))
                fprintf("] [m/s]\n")
            end
                                    
            if ~isempty(obj.inds_b_s)
                fprintf("\t\tBias s:        [")
                fprintf("%.1f ", (S_init.std.b_s))
                fprintf("] [m/s^2]\n")
            end
            if ~isempty(obj.inds_b_g)
                fprintf("\t\tBias gyro:        [")
                fprintf("%.1f ", rad2deg(S_init.std.b_g))
                fprintf("] [deg/s]\n")
            end
        end
    end
end

