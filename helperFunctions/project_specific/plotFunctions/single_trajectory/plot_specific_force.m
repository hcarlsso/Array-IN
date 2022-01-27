function [f,ax] = plot_specific_force(data, t, cases_plot, caseOpt, plotType)

    if nargin < 5
        plotType = "normal";
    end

    plotOpt = struct;
    plotOpt.variable_name_mean = "s";
    plotOpt.variable_name_var = "s_std";
    plotOpt.transformation = @(x) x;
    plotOpt.title_label = "Specific force";
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
