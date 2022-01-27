function vels = compute_omega(inp)
theta = inp.theta;
theta_dot = inp.theta_dot;
theta_dot_2 = inp.theta_dot_2;

phi = inp.phi;
phi_dot = inp.phi_dot;
phi_dot_2 = inp.phi_dot_2;

N = length(theta);

% The angular velocity in navigation frame
w_n = zeros(3,N);
w_n(1,:) = phi_dot.*(-sin(theta)); % x
w_n(2,:) = phi_dot.*(cos(theta));  % y
w_n(3,:) = theta_dot;  % z

% The angular acceleration in navigation frame
w_dot_n = zeros(3,N);
w_dot_n(1,:) = -phi_dot_2.*sin(theta) - phi_dot.*theta_dot.*cos(theta); % x
w_dot_n(2,:) = phi_dot_2.*cos(theta) - phi_dot.*theta_dot.*sin(theta);  % y
w_dot_n(3,:) = theta_dot_2;  % z

% Body frame
w_b = zeros(3,N);
w_b(1,:) =  theta_dot.*cos(phi); % r
w_b(2,:) = -theta_dot.*sin(phi); % phi
w_b(3,:) =  phi_dot; % theta

w_dot_b = zeros(3,N);
w_dot_b(1,:) =  theta_dot_2.*cos(phi) - phi_dot.*theta_dot.*sin(phi); % r
w_dot_b(2,:) = -theta_dot_2.*sin(phi) - phi_dot.*theta_dot.*cos(phi); % phi
w_dot_b(3,:) =  phi_dot_2; % theta

vels.w_b = w_b;
vels.w_dot_b = w_dot_b;

vels.w_n = w_n;
vels.w_dot_n = w_dot_n;
end
