function [f,ax] = rmse_components_rotation(data, IN_time_array, cases_plot, casePlotOpts)

    figurePlotOpts = struct;
    figurePlotOpts.variable_name = "R";
    figurePlotOpts.transformation = @rad2deg;
    figurePlotOpts.title_label = "RMSE component-wise Rotation";
    figurePlotOpts.y_unit = "[deg]";


    [f,ax] = rmse_components_general(data, IN_time_array, cases_plot, casePlotOpts, figurePlotOpts);

end
