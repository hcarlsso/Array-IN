function [f,a] = plot_statistics_position(data, IN_time_array, cases_plot, casePlotOpts, plotType, extras)

    if nargin < 5
        plotType = "error";
    end
    if nargin < 6
        extras = struct;
    end
    figurePlotOpts = extras;
    figurePlotOpts.variable_name = "p";
    figurePlotOpts.transformation = @(x) x;    
    figurePlotOpts.y_unit = "[m]";
    
    if isfield(extras, "title")
        figurePlotOpts.title_label = sprintf("%s ", extras.title);
    else
        figurePlotOpts.title_label = "";
    end
    
    if strcmp(plotType, "error")
        figurePlotOpts.title_label = figurePlotOpts.title_label + "Position Error";
        [f,a] = IN_error_general(data, IN_time_array, cases_plot, casePlotOpts, figurePlotOpts);
    elseif strcmp(plotType, "rmse-all")
        figurePlotOpts.title_label = figurePlotOpts.title_label + "RMSE Position";
        [f,a] = rmse_all_components_general(data, IN_time_array, cases_plot, casePlotOpts, figurePlotOpts);
    elseif strcmp(plotType, "rmse-comp")
        figurePlotOpts.title_label = figurePlotOpts.title_label + "RMSE component-wise Position";
        [f,a] = rmse_components_general(data, IN_time_array, cases_plot, casePlotOpts, figurePlotOpts);
    else
        error("Invalid plot type %s", plotType)        
    end
end
