function [m] = get_spherical_motion(t, inp)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if strcmp(inp.phi, "sinus")
    [phi, phi_dot, phi_dot_2] = get_sinus(t, inp.phi_params);
elseif strcmp(inp.phi, "linear")
    [phi, phi_dot, phi_dot_2] = get_linear(t, inp.phi_params);    
elseif strcmp(inp.phi, "quadratic")
    [phi, phi_dot, phi_dot_2] = get_quadratic(t, inp.phi_params);
elseif strcmp(inp.phi, "poly")    
    [phi, phi_dot, phi_dot_2] = get_polynomial(t, inp.phi_params);
elseif strcmp(inp.phi, "constant")    
    [phi, phi_dot, phi_dot_2] = get_constant(t, inp.phi_params);
else
    error("No correct motion for phi")
end

if strcmp(inp.theta, "sinus")
    [theta, theta_dot, theta_dot_2] = get_sinus(t, inp.theta_params);
elseif strcmp(inp.theta, "linear")
    [theta, theta_dot, theta_dot_2] = get_linear(t, inp.theta_params);
elseif strcmp(inp.theta, "quadratic")
    [theta, theta_dot, theta_dot_2] = get_quadratic(t, inp.theta_params);
elseif strcmp(inp.theta, "poly")
    [theta, theta_dot, theta_dot_2] = get_polynomial(t, inp.theta_params);
elseif strcmp(inp.theta, "constant")
    [theta, theta_dot, theta_dot_2] = get_constant(t, inp.theta_params);
else
    error("No correct motion for theta")
end
m.phi = phi;
m.phi_dot = phi_dot;
m.phi_dot_2 = phi_dot_2;

m.theta = theta;
m.theta_dot = theta_dot;
m.theta_dot_2 = theta_dot_2;

end

function [s, s_dot, s_dot_2] = get_constant(t, inp)
    if isfield(inp,"A")
        A = inp.A;
    else
        A = 1;
    end
    s = A*ones(size(t));
    s_dot = zeros(size(t));
    s_dot_2 = zeros(size(t));

end
function [s, s_dot, s_dot_2] = get_sinus(t, inp)
    if isfield(inp,"A") 
        A = inp.A;
    else
        A = 1;
    end
    if isfield(inp,"f") 
        f = inp.f;
    else
        f = 1;
    end
    if isfield(inp,"b") 
        b = inp.b;
    else
        b = 0;
    end
    s = A.*sin(2*pi*f*t) + b;
    s_dot = A.*cos(2*pi*f*t)*2*pi*f;
    s_dot_2 = -A.*sin(2*pi*f*t)*(2*pi*f)^2;    
end
function [s, s_dot, s_dot_2] = get_linear(t, inp)
    if isfield(inp,"A") 
        A = inp.A;
    else
        A = 1;
    end
    s = A*t;
    s_dot = A*ones(size(t));
    s_dot_2 = zeros(size(t));
end
function [s, s_dot, s_dot_2] = get_quadratic(t, inp)
    if isfield(inp,"A") 
        A = inp.A;
    else
        A = 1;
    end
    s = A*t.^2;
    s_dot = 2*A*t;
    s_dot_2 = 2*A*ones(size(t));
end
function [s, s_dot, s_dot_2] = get_polynomial(t, inp)
    p = inp.p;
    s = polyval(p, t);
    p1 = polyder(p);
    s_dot = polyval(p1, t);
    p2 = polyder(p1);
    s_dot_2 = polyval(p2, t);
end
