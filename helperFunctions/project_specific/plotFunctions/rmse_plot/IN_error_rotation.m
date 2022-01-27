function [f, ax] = IN_error_rotation(data, IN_time_array, cases_plot, casePlotOpts)

    figurePlotOpts = struct;
    figurePlotOpts.variable_name = "R";
    figurePlotOpts.transformation = @rad2deg;
    figurePlotOpts.title_label = "Rotation Error";
    figurePlotOpts.y_unit = "[deg]";

    [f,ax] = IN_error_general(data, IN_time_array, cases_plot, casePlotOpts, figurePlotOpts);

end
