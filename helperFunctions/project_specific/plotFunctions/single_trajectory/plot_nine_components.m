function [f,ax] = plot_nine_components(dataTot, t, cases_plot, caseOpt, plotOpt)

pred_type = plotOpt.pred_type;
v_name = plotOpt.variable_name_mean;
f_trans = plotOpt.transformation;
title_label = plotOpt.title_label;
y_unit = plotOpt.y_unit;

N_end = length(t);
colorOrder = colororder;

if isfield(plotOpt,"components")
    directions = plotOpt.components;
else
    directions = reshape(["(1,1)","(1,2)","(1,3)";
        "(2,1)","(2,2)","(2,3)";
        "(3,1)","(3,2)","(3,3)"],[],1);
end

if isfield(plotOpt,"show_cov")
    show_cov = plotOpt.show_cov; 
else
    show_cov = true;
end

if isfield(plotOpt,"figure")
    f = plotOpt.figure; 
else
    f = figure();
end

if isfield(plotOpt,"axes")
    ax = plotOpt.axes; 
else
    ax = zeros(9,1);
    for i = 1:9
        ax(i) = subplot(3,3,i); hold on;
    end
end

for i = 1:9

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
        if ~isfield(res_pred.mean,v_name)
            error("%s is not in %s",v_name, c)
        end
        data = f_trans(res_pred.mean.(v_name));
        leg(1,i_c) = plot(ax(i), t, data(i,:), ...
            "DisplayName", res.label, ...
            "Color", colorOrder(i_c,:), ...
            "Linestyle", resLineSpecs.ls_c, ...
            "Marker", resLineSpecs.m_c, ...
            "MarkerIndices", resLineSpecs.m_offset:resLineSpecs.m_space:N_end);

        if show_cov && isfield(res_pred.std, v_name)
            data_sig = f_trans(res_pred.std.(v_name));
            if isfield(caseOpt,c) && isfield(caseOpt.(c),"cov")
                resLineSpecs = get_ls_specs(caseOpt.(c).cov);
            else
                resLineSpecs = get_ls_specs(struct);
                resLineSpecs.ls_c = "--";
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
    grid(ax(i),"on")

    title(ax(i),title_label)
    if isfield(plotOpt,"legend")
        leg_opt = plotOpt.legend;
    else
        leg_opt = {"Location","best","NumColumns",1, 'interpreter',"latex"};
    end
    legend(reshape(leg(~isnan(leg)),[],1), leg_opt{:})
    xlabel(ax(i),"Time [s]")
    ylabel(ax(i),sprintf("%s %s", directions(i), y_unit))
end

end
