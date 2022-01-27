function [f,ax] = plot_three_components_norm_error_log(dataTot, t, cases_plot, caseOpt, plotOpt)

pred_type = plotOpt.pred_type;
v_mean = plotOpt.variable_name_mean;
v_var = plotOpt.variable_name_var;
f_trans = plotOpt.transformation;
title_label = plotOpt.title_label;
y_unit = plotOpt.y_unit;

N_end = length(t);
colorOrder = colororder;


f = figure();
ax = gca();
hold on;

leg = nan(2,length(cases_plot));
for i_c = 1:length(cases_plot)
    c = cases_plot(i_c);
    res = dataTot.(c);
    res_pred = dataTot.(c).(pred_type);

    if isfield(caseOpt,c) && isfield(caseOpt.(c),"mean")
        resLineSpecs = get_ls_specs(caseOpt.(c).mean);
    else
        resLineSpecs = get_ls_specs(struct);
    end
    if ~isfield(res,"err")
        warning("%s not in %s","err", c)
        continue
    end
    if ~isfield(res.err,v_mean)
        warning("%s not in %s",v_mean, c)
        continue
    end
    data = f_trans(res.err.(v_mean));
    leg(1,i_c) = plot(t, norm_time(data), ...
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
            resLineSpecs.ls_c = "--";
        end

        leg(2,i_c) = plot(t, 3*norm_time(data_sig), ...
            "DisplayName", sprintf("%s%s%s", res.label, newline, "$3 \sqrt{\sum \sigma_i }$"), ...
            "Color", colorOrder(i_c,:), ...
            "Linestyle", resLineSpecs.ls_c, ...
            "Marker", resLineSpecs.m_c, ...
            "MarkerIndices", resLineSpecs.m_offset:resLineSpecs.m_space:N_end);
    end
end
grid on
set(ax, "YScale","log")
title(title_label)
if isfield(plotOpt,"legend")
    leg_opt = plotOpt.legend;
else
    leg_opt = {"Location","bestoutside","NumColumns",1, 'interpreter',"latex"};
end
legend(reshape(leg(~isnan(leg)),[],1), leg_opt{:})
xlabel("Time [s]")
ylabel(sprintf("%s", y_unit))


end
