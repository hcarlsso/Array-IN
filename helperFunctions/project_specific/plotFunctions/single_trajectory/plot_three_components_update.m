function [ax] = plot_three_components_update(ax, dataTot, t, cases_plot, caseOpt, plotOpt)

pred_type = plotOpt.pred_type;
v_mean = plotOpt.variable_name_mean;
v_var = plotOpt.variable_name_var;
f_trans = plotOpt.transformation;
title_label = plotOpt.title_label;
y_unit = plotOpt.y_unit;

N_end = length(t);
colorOrder = colororder;

directions = ["x","y","z"];

for i = 1:3
    hold(ax(i),"on");

    leg = zeros(2,length(cases_plot));
    for i_c = 1:length(cases_plot)
        c = cases_plot(i_c);
        res = dataTot.(c);
        res_pred = dataTot.(c).(pred_type);

        if isfield(caseOpt,c) && isfield(caseOpt.(c),"mean")
            resLineSpecs = get_ls_specs(caseOpt.(c).mean);
        else
            resLineSpecs = get_ls_specs(struct);
        end
        data = f_trans(res_pred.(v_mean));
        leg(1,i_c) = plot(ax(i),t, data(i,:), ...
            "DisplayName", res.label, ...
            "Color", colorOrder(i_c,:), ...
            "Linestyle", resLineSpecs.ls_c, ...
            "Marker", resLineSpecs.m_c, ...
            "MarkerIndices", resLineSpecs.m_offset:resLineSpecs.m_space:N_end);

        if isfield(res_pred, v_var)
            data_sig = f_trans(res_pred.(v_var));
            if isfield(caseOpt,c) && isfield(caseOpt.(c),"cov")
                resLineSpecs = get_ls_specs(caseOpt.(c).cov);
            else
                resLineSpecs = get_ls_specs(struct);
            end

            leg(2,i_c) = plot(ax(i), t, data(i,:) + 3*data_sig(i,:), ...
                "DisplayName", sprintf("%s $3\\sigma$", res.label), ...
                "Color", colorOrder(i_c,:), ...
                "Linestyle", resLineSpecs.ls_c, ...
                "Marker", resLineSpecs.m_c, ...
                "MarkerIndices", resLineSpecs.m_offset:resLineSpecs.m_space:N_end);

            plot(ax(i), t, data(i,:) - 3*data_sig(i,:), ...
                "DisplayName", res.label, ...
                "Color", colorOrder(i_c,:), ...
                "Linestyle", resLineSpecs.ls_c, ...
                "Marker", resLineSpecs.m_c, ...
                "MarkerIndices", resLineSpecs.m_offset:resLineSpecs.m_space:N_end);
        else
            leg(2,i_c) = nan;
        end
    end
    grid on

    title(ax(i), title_label)
    if isfield(plotOpt,"legend")
        leg_opt = plotOpt.legend;
    else
        leg_opt = {"Location","bestoutside","NumColumns",1, 'interpreter',"latex"};
    end
    legend(reshape(leg(~isnan(leg)),[],1), leg_opt{:})
    xlabel(ax(i), "Time [s]")
    ylabel(ax(i), sprintf("%s %s", directions(i), y_unit))
end

end
