function [f,ax] = plot_three_components_filt_pred(dataTot, t, cases_plot, caseOpt, plotOpt)

pred_types = ["pred", "filt"];
v_mean = plotOpt.variable_name_mean;
v_var = plotOpt.variable_name_var;
f_trans = plotOpt.transformation;
title_label = plotOpt.title_label;
y_unit = plotOpt.y_unit;

N_end = length(t);
colorOrder = colororder;
get_color = @(i) colorOrder(mod1(i,size(colorOrder,1)), :);

if isfield(plotOpt,"components")
    directions = plotOpt.components;
else
    directions = ["x","y","z"];
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
    ax = zeros(3,1);
    for i = 1:3
        ax(i) = subplot(3,1,i); hold on;
    end
end

N_c = length(cases_plot);
N_p = length(pred_types);
for i = 1:3

    leg = nan(2,2,length(cases_plot));
    for i_c = 1:N_c
        c = cases_plot(i_c);
        res = dataTot.(c);
        for i_p = 1:N_p
            ii = sub2ind([N_p, N_c], i_p, i_c);
            pred_type = pred_types(i_p);
            
            if ~isfield(dataTot.(c),pred_type)
                continue
            end
                
            res_pred = dataTot.(c).(pred_type);
            
            if isfield(caseOpt,c) && isfield(caseOpt,pred_type) && isfield(caseOpt.(pred_type).(c),"mean")
                resLineSpecs = get_ls_specs(caseOpt.(pred_type).(c).mean);
            else
                resLineSpecs = get_ls_specs(struct);
            end
            if isfield(res_pred, v_mean)
                data = f_trans(res_pred.(v_mean));
                leg(1, i_p, i_c) = plot(ax(i), t, data(i,:), ...
                    "DisplayName", sprintf("%s %s", res.label, pred_type), ...
                    "Color", get_color(ii), ...
                    "Linestyle", resLineSpecs.ls_c, ...
                    "Marker", resLineSpecs.m_c, ...
                    "MarkerIndices", resLineSpecs.m_offset:resLineSpecs.m_space:N_end);
            end
            
            if show_cov && isfield(res_pred, v_var)
                data_sig = f_trans(res_pred.(v_var));
                if isfield(caseOpt,c) && isfield(caseOpt,pred_type) && isfield(caseOpt.(pred_type).(c),"cov")
                    resLineSpecs = get_ls_specs(caseOpt.(pred_type).(c).cov);
                else
                    resLineSpecs = get_ls_specs(struct);
                    resLineSpecs.ls_c = "--";
                end
                
                leg(2,i_p,i_c) = plot(ax(i), t, data(i,:) + 3*data_sig(i,:), ...
                    "DisplayName", sprintf("%s %s $3\\sigma$", res.label, pred_type), ...
                    "Color", get_color(ii), ...
                    "Linestyle", resLineSpecs.ls_c, ...
                    "Marker", resLineSpecs.m_c, ...
                    "MarkerIndices", resLineSpecs.m_offset:resLineSpecs.m_space:N_end);
                
                plot(ax(i), t, data(i,:) - 3*data_sig(i,:), ...
                    "DisplayName", res.label, ...
                    "Color", get_color(ii), ...
                    "Linestyle", resLineSpecs.ls_c, ...
                    "Marker", resLineSpecs.m_c, ...
                    "MarkerIndices", resLineSpecs.m_offset:resLineSpecs.m_space:N_end);
            end
        end
    end
    grid(ax(i),"on")

    title(ax(i),title_label)
    if isfield(plotOpt,"legend")
        leg_opt = plotOpt.legend;
    else
        leg_opt = {"Location","bestoutside","NumColumns",1, 'interpreter',"latex"};
    end
    legend(reshape(leg(~isnan(leg)),[],1), leg_opt{:})
    xlabel(ax(i),"Time [s]")
    ylabel(ax(i),sprintf("%s %s", directions(i), y_unit))
end

end
