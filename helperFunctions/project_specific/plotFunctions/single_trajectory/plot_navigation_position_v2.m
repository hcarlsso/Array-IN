function [f,ax] = plot_navigation_position_v2(data, t,  caseOpt, plotType, extras)

    if nargin < 4
        plotType = "normal";
    end

    if nargin == 5
        plotOpt = extras;
        fprintf("Using Extras\n")
    else
        plotOpt = struct;
    end


    plotOpt.variable_name_mean = "p";
    plotOpt.variable_name_var = "p_std";
    plotOpt.transformation = @(x) x;
    if isfield(plotOpt, "title")
        plotOpt.title_label = sprintf("%s ",plotOpt.title);
    else
        plotOpt.title_label = "";
    end

    plotOpt.title_label = plotOpt.title_label + "Navigation position";
    plotOpt.y_unit = "[m]";
    plotOpt.pred_type = "filt";


    if plotType == "error"
        [f,ax] = plot_three_components_error_v2(data, t,  caseOpt, plotOpt);
    else
        error("wrong")
    end


end
