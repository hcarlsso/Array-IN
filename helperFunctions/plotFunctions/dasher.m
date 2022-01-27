function [xDash] = dasher(x,offset,space)
%DASHER Make line dashed with differnt offsets.
xDash = x;
if offset ~= 0 || space ~= 0
    xDash(offset:space:length(x)) = NaN;
end
end

