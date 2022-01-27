function [f,a] = plot_statistics_position_v2(data, IN_time_array, casePlotOpts, plotType, extras)

    if nargin < 4
        plotType = "error";
    end
    if nargin < 5
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
    
    if strcmp(plotType, "rmse-all")
        figurePlotOpts.title_label = figurePlotOpts.title_label + "RMSE Position";
        [f,a] = rmse_all_components_general_v2(data, IN_time_array, casePlotOpts, figurePlotOpts);
    else
        error("Invalid plot type %s", plotType)        
    end
end
