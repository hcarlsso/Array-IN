function [f] = scale_figure_rect(f, w, h)
%SCALE_FIGURE Scale figure by width and height
%
%    f = scale_figure_rect(f, w, h)
   
pos = get(f, "Position");
pos(3) = pos(3)*w;
pos(4) = pos(4)*h;
set(f, "Position", pos)
end

