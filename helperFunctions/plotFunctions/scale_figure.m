function [f] = scale_figure(f, s)
%SCALE_FIGURE Summary of this function goes here
%   Detailed explanation goes here
pos = get(f, "Position");

set(f, "Position", pos.*s)
end

