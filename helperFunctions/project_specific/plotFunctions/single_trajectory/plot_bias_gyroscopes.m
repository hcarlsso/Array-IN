function [f,ax] = plot_bias_gyroscopes(data, t, cases_plot, caseOpt, plotType, extras)

    if nargin < 5
        plotType = "normal";
    end

    if nargin == 6
        plotOpt = extras;
    else
        plotOpt = struct;
    end


    plotOpt.variable_name = "b_g";
    plotOpt.transformation = @rad2deg;
    if isfield(plotOpt, "title")
        plotOpt.title_label = sprintf("%s, Bias gyroscopes",plotOpt.title);
    else
        plotOpt.title_label = "Bias gyroscopes";
    end
    plotOpt.y_unit = "[deg/s]";
    if ~isfield(plotOpt, "path")       
        plotOpt.path = ["filt"];
    end

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
