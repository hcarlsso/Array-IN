function [f,ax] = plot_navigation_acceleration(data, t, cases_plot, caseOpt, plotType)

    if nargin < 5
        plotType = "normal";
    end

    plotOpt = struct;
    plotOpt.variable_name_mean = "v_dot";
    plotOpt.variable_name_var = "v_dot_std";
    plotOpt.transformation = @(x) x;
    plotOpt.title_label = "Navigation Acceleration";
    plotOpt.y_unit = "[m/s^2]";
    plotOpt.pred_type = "pred";

    if plotType == "error"
        [f,ax] = plot_three_components_error(data, t, cases_plot, caseOpt, plotOpt);
    elseif plotType == "error_log"
        [f,ax] = plot_three_components_error_log(data, t, cases_plot, caseOpt, plotOpt);
    elseif plotType == "norm_error_log"
        [f,ax] = plot_three_components_norm_error_log(data, t, cases_plot, caseOpt, plotOpt);
    else
        [f,ax] = plot_three_components(data, t, cases_plot, caseOpt, plotOpt);
    end

end
