function [f,a] = rmse_all_components_position(data, IN_time_array, cases_plot, casePlotOpts)

    figurePlotOpts = struct;
    figurePlotOpts.variable_name = "p";
    figurePlotOpts.transformation = @(x) x;
    figurePlotOpts.title_label = "RMSE Position";
    figurePlotOpts.y_unit = "[m]";

    [f,a] = rmse_all_components_general(data, IN_time_array, cases_plot, casePlotOpts, figurePlotOpts);

end
