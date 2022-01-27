function [f,ax] = plot_rotation(data, t, cases_plot, caseOpt, plotType, extras)
% Only works for error

if nargin == 6
    plotOpt = extras;
else
    plotOpt = struct;
end


plotOpt.variable_name = "R";
plotOpt.transformation = @rad2deg;
plotOpt.y_unit = "[deg]";

if ~isfield(plotOpt, "path")       
    plotOpt.path = ["filt"];
end

if isfield(plotOpt, "title")
    plotOpt.title_label = sprintf("%s ",plotOpt.title);
else
    plotOpt.title_label = " ";
end

if nargin < 5
    plotType = "normal";
end

if plotType == "error"
    plotOpt.title_label = plotOpt.title_label + "Rotation Error";
    [f,ax] = plot_three_components_error(data, t, cases_plot, caseOpt, plotOpt);
elseif plotType == "error_log"
    plotOpt.title_label = plotOpt.title_label + "Rotation Error";
    [f,ax] = plot_three_components_error_log(data, t, cases_plot, caseOpt, plotOpt);
elseif plotType == "norm_error_log"
    plotOpt.title_label = plotOpt.title_label + "Rotation Error";
    [f,ax] = plot_three_components_norm_error_log(data, t, cases_plot, caseOpt, plotOpt);
else
    plotOpt.title_label = plotOpt.title_label + "Rotation";
    plotOpt.components = ["roll","pitch","yaw"];
    plotOpt.transformation = @(x) rad2deg(my_rotm2eul(x));
    plotOpt.show_cov = false;
    [f,ax] = plot_three_components(data, t, cases_plot, caseOpt, plotOpt);
end

end
