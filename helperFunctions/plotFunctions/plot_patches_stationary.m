function plot_patches_stationary(ax, t, zupt)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    yLim=get(ax,'YLim');
    xLim=get(ax,'XLim');
    start = zeros(1);
    N_start = 1;
    N_stop = 1;
    stop = zeros(1);
    stationary = true;
    for n = 1:length(t)
        if (stationary == true) && (zupt(n) == false)
            start(N_start) = t(n);
            stationary = false;
            N_start = N_start + 1;
        elseif (stationary == false) && (zupt(n) == true)
            stop(N_stop) = t(n);
            stationary = true;
            N_stop = N_stop + 1;
        end
    end

    patch([0 0 start(1) start(1)],[yLim(2) yLim(1) yLim(1) yLim(2)],ones(1,4),'FaceColor','b','facealpha',0.2);
    for i=1:numel(start)
        patch([start(i) start(i) stop(i) stop(i)],[yLim(2) yLim(1) yLim(1) yLim(2)],ones(1,4),'FaceColor','r','facealpha',0.2);
    end
    for i=1:numel(stop) -1
        patch([stop(i) stop(i) start(i+1) start(i+1)],[yLim(2) yLim(1) yLim(1) yLim(2)],ones(1,4),'FaceColor','b','facealpha',0.2);
    end
    patch([stop(end) stop(end) xLim(2) xLim(2)],[yLim(2) yLim(1) yLim(1) yLim(2)],ones(1,4),'FaceColor','b','facealpha',0.2);

    xlim(ax, xLim);
    ylim(ax, yLim);
    

end

