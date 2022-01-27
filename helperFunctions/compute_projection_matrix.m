function [M] = compute_projection_matrix(H, Q)
%COMPUTE_PROJECTION_MATRIX Summary of this function goes here
%   Detailed explanation goes here
H_t_Q_inv = H'/Q;
M = (H_t_Q_inv * H)\H_t_Q_inv;

end

