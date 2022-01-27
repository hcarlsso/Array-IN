function [f, ax] = plot_angular_velocity_filt_and_pred(data, t, cases_plot, caseOpt)


    plotOpt = struct;
    plotOpt.variable_name_mean = "w";
    plotOpt.variable_name_var = "w_std";
    plotOpt.transformation = @rad2deg;
    plotOpt.title_label = "Angular Velocity";
    plotOpt.y_unit = "[deg/s]";
    plotOpt.pred_type = "filt";

    f = figure;
    ax = zeros(3,1);
    for i = 1:3
        ax(i) = subplot(3,1,i);
        hold on;
        grid on;
    end

    plot_three_components_update(ax, data, t, cases_plot, caseOpt, plotOpt);


    plotOpt = struct;
    plotOpt.variable_name_mean = "w";
    plotOpt.variable_name_var = "w_std";
    plotOpt.transformation = @rad2deg;
    plotOpt.title_label = "Angular Velocity";
    plotOpt.y_unit = "[deg/s]";
    plotOpt.pred_type = "pred";

    plot_three_components_update(ax, data, t, cases_plot, caseOpt, plotOpt);


end
