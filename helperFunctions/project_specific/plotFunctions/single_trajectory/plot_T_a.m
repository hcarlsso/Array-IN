function [f,ax] = plot_T_a(data, t, cases_plot, caseOpt, plotType, extras)

    if nargin < 5
        plotType = "normal";
    end
    
    if nargin == 6
        plotOpt = extras;
    else
        plotOpt = struct;
    end

    plotOpt.variable_name_mean = "T_a";
    plotOpt.transformation = @(x) x;
    plotOpt.title_label = "T_a";
    plotOpt.y_unit = "[-]";
    plotOpt.pred_type = "filt";

    if plotType == "normal"
        [f,ax] = plot_nine_components(data, t, cases_plot, caseOpt, plotOpt);
    else
        error("Invalid choice")
    end


end
