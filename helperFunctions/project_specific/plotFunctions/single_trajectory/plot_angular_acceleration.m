function [f,ax] = plot_angular_acceleration(data, t, cases_plot, caseOpt, plotType)

    if nargin < 5
        plotType = "normal";
    end

    plotOpt = struct;
    plotOpt.variable_name_mean = "omega_dot";
    plotOpt.variable_name_var = "omega_dot_std";
    plotOpt.transformation = @rad2deg;
    plotOpt.title_label = "Angular Acceleration";
    plotOpt.y_unit = "[deg/s^2]";
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
