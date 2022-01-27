function [f,ax] = plot_angular_velocity(data, t, cases_plot, caseOpt, plotType, extras)

    if nargin < 5
        plotType = "normal";
    end
    if nargin == 6
        plotOpt = extras;
    else
        plotOpt = struct;
    end


    plotOpt.variable_name_mean = "w";
    plotOpt.variable_name_var = "w_std";
    plotOpt.transformation = @rad2deg;
    plotOpt.title_label = "Angular Velocity";
    plotOpt.y_unit = "[deg/s]";
    plotOpt.pred_type = "filt";

    if plotType == "error"
        [f,ax] = plot_three_components_error(data, t, cases_plot, caseOpt, plotOpt);
    elseif plotType == "error_log"
        [f,ax] = plot_three_components_error_log(data, t, cases_plot, caseOpt, plotOpt);
    elseif plotType == "norm_error_log"
        [f,ax] = plot_three_components_norm_error_log(data, t, cases_plot, caseOpt, plotOpt);
    elseif plotType == "filt_and_pred"
        [f,ax] = plot_three_components_filt_pred(data, t, cases_plot, caseOpt, plotOpt);
    else
        [f,ax] = plot_three_components(data, t, cases_plot, caseOpt, plotOpt);
    end

end
