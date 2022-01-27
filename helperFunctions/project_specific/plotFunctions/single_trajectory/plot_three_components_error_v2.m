function [f,ax] = plot_three_components_error_v2(dataTot, t, caseOpt, plotOpt)

pred_type = plotOpt.pred_type;
v_mean = plotOpt.variable_name_mean;
v_var = plotOpt.variable_name_var;
f_trans = plotOpt.transformation;
title_label = plotOpt.title_label;
y_unit = plotOpt.y_unit;

N_end = length(t);
colorOrder = colororder;

directions = ["x","y","z"];

if isfield(plotOpt,"figure")
    f = plotOpt.figure; 
else
    f = figure();
end

if isfield(plotOpt,"axes")
    ax = plotOpt.axes; 
else
    ax = zeros(3,1);
    for i = 1:3
        ax(i) = subplot(3,1,i); hold on;
    end
end

if isfield(plotOpt,"show_cov")
    show_cov = plotOpt.show_cov; 
else
    show_cov = true;
end
for i = 1:3
    leg = nan(2,numel(dataTot));
    for i_c = 1:numel(dataTot)
        res = dataTot(i_c);
        res = res{1};
        caseOpt_i = caseOpt(i_c);
        if ~isfield(res,pred_type)
            warning("%s not in %s",pred_type, c)
            continue
        end
        res_pred = res.(pred_type);

        if isstruct(caseOpt_i) && isfield(caseOpt_i,"mean")
            resLineSpecs = get_ls_specs(caseOpt_i.mean);
        else
            resLineSpecs = get_ls_specs(struct);
        end
        if isfield(res,"err") && isfield(res.err,v_mean)
            data = f_trans(res.err.(v_mean));
            leg(1,i_c) = plot(ax(i), t, data(i,:), ...
                "DisplayName", res.label, ...
                "Color", colorOrder(i_c,:), ...
                "Linestyle", resLineSpecs.ls_c, ...
                "Marker", resLineSpecs.m_c, ...
                "MarkerIndices", resLineSpecs.m_offset:resLineSpecs.m_space:N_end);
        end

        if show_cov && isfield(res_pred, v_var)
            data_sig = f_trans(res_pred.(v_var));
            if isstruct(caseOpt_i) && isfield(caseOpt_i,"cov")
                resLineSpecs = get_ls_specs(caseOpt_i.cov);
            else
                resLineSpecs = get_ls_specs(struct);
                resLineSpecs.ls_c = "--";
            end

            leg(2,i_c) = plot(ax(i), t, 3*data_sig(i,:), ...
                "DisplayName", sprintf("%s $3\\sigma$", res.label), ...
                "Color", colorOrder(i_c,:), ...
                "Linestyle", resLineSpecs.ls_c, ...
                "Marker", resLineSpecs.m_c, ...
                "MarkerIndices", resLineSpecs.m_offset:resLineSpecs.m_space:N_end);

            plot(ax(i), t, -3*data_sig(i,:), ...
                "DisplayName", sprintf("%s %3\\sigma$", res.label), ...
                "Color", colorOrder(i_c,:), ...
                "Linestyle", resLineSpecs.ls_c, ...
                "Marker", resLineSpecs.m_c, ...
                "MarkerIndices", resLineSpecs.m_offset:resLineSpecs.m_space:N_end);
        end
    end
    grid(ax(i),"on")

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
