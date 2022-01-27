function [f, ax] = IN_error_position(data, IN_time_array, cases_plot, casePlotOpts)
    figurePlotOpts = struct;
    figurePlotOpts.variable_name = "p";
    figurePlotOpts.transformation = @(x) x;
    figurePlotOpts.title_label = "Position Error";
    figurePlotOpts.y_unit = "[m]";

    [f,ax] = IN_error_general(data, IN_time_array, cases_plot, casePlotOpts, figurePlotOpts);

end
