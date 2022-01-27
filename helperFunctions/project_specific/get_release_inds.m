function res = get_release_inds(time, release_times, IN_time, T)


%IN_time = 5; 
IN_samples = IN_time/T;
inds_growth = zeros(IN_samples, length(release_times));
for i_t = 1:length(release_times)
    inds_t = find(time >= release_times(i_t));
    inds_growth(:,i_t) = inds_t(1:IN_samples);
    
end
IN_time_array = (0:IN_samples-1)*T;
res = struct;
res.inds_growth = inds_growth;
res.IN_time_array = IN_time_array;

end