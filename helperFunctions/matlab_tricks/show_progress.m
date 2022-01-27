function show_progress(n,N, N_show)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
if mod(n,N_show) == 0
    fprintf("%d / %d\n", n,N);
    waitbar(n/N)
end
 
end

