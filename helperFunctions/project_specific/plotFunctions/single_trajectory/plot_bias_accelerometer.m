function [f,ax] = plot_bias_accelerometer(data, t, cases_plot, caseOpt, plotType, extras)

    if nargin < 5
        plotType = "normal";
    end
    
    if nargin == 6
        plotOpt = extras;
    else
        plotOpt = struct;
    end

    plotOpt.variable_name_mean = "b_a";
    plotOpt.variable_name_var = "b_a_std";
    plotOpt.transformation = @(x) x;
    plotOpt.title_label = "Bias accelerometer";
    plotOpt.y_unit = "[m/s^2]";
    plotOpt.pred_type = "filt";

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
