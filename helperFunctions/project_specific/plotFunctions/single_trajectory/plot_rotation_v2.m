function [f,ax] = plot_rotation_v2(data, t, caseOpt, plotType, extras)
% Only works for error
    if nargin < 4
        plotType = "normal";
    end

    if nargin == 5
        plotOpt = extras;
        fprintf("Using Extras\n")
    else
        plotOpt = struct;
    end


    plotOpt.variable_name_mean = "R";
    plotOpt.variable_name_var = "R_std";
    plotOpt.transformation = @rad2deg;
    if isfield(plotOpt, "title")
        plotOpt.title_label = sprintf("%s ",plotOpt.title);
    else
        plotOpt.title_label = "";
    end

    plotOpt.title_label = plotOpt.title_label + "Rotation";
    plotOpt.y_unit = "[deg]";
    plotOpt.pred_type = "filt";


    if plotType == "error"
        [f,ax] = plot_three_components_error_v2(data, t,  caseOpt, plotOpt);
    else
        error("wrong")
    end

end
