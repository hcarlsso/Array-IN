target_board = 'MIMU4444';

% 500 Hz
rate_div = 2;

% All IMUs 32 
active_imus = 1:32;

threshold_factor = 5.0;
min_period = 500;
min_diff_of_sets = 1e-2;
max_period = 20e4;