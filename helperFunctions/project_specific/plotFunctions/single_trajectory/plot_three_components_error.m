function [f,ax] = plot_three_components_error(dataTot, t, cases_plot, caseOpt, plotOpt)

path_struct = plotOpt.path;
variable_name = plotOpt.variable_name;
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

if isfield(plotOpt,"show_mean")
    show_mean = plotOpt.show_mean; 
else
    show_mean = true;
end

for i = 1:3
    leg = nan(2,size(cases_plot,1));
    for i_c = 1:size(cases_plot,1)
        case_path = cases_plot(i_c, :);
        c = case_path(end);
        path_struct_i = [case_path, path_struct];
        path_struct_i_label = [case_path, path_struct(1:end-1),"label"];
        try 
            path_struct_i_struct = num2cell(path_struct_i);
            res = getfield(dataTot, path_struct_i_struct{:});
        catch 
            warning("%s is not in %s",c, join([path_struct{:}],"/"))
            continue
        end    
        
        try
            path_struct_i_label_struct = num2cell(path_struct_i_label);
            label_2 = getfield(dataTot, path_struct_i_label_struct{:});
        catch 
            warning("label %s is not in %s",c, join([path_struct{:}],"/"))
            label_2 = "";
        end    
        try
            label_1 = dataTot.(case_path(1)).("label");
        catch
            label_1 = "";
        end
        label = label_2 + newline + label_1;
        

        if isfield(caseOpt,c) && isfield(caseOpt.(c),"mean")
            resLineSpecs = get_ls_specs(caseOpt.(c).mean);
        else
            resLineSpecs = get_ls_specs(struct);
        end
        
        if show_mean && isfield(res, "mean") && isfield(res.("mean"), variable_name)
            data = f_trans(res.("mean").(variable_name));
            leg(1,i_c) = plot(ax(i), t, data(i,:), ...
                "DisplayName", label, ...
                "Color", colorOrder(i_c,:), ...
                "Linestyle", resLineSpecs.ls_c, ...
                "Marker", resLineSpecs.m_c, ...
                "MarkerIndices", resLineSpecs.m_offset:resLineSpecs.m_space:N_end);
        end        

        if show_cov && isfield(res.("std"), variable_name)
            data_sig = f_trans(res.("std").(variable_name));
            if isfield(caseOpt,c) && isfield(caseOpt.(c),"cov")
                resLineSpecs = get_ls_specs(caseOpt.(c).cov);
            else
                resLineSpecs = get_ls_specs(struct);
                resLineSpecs.ls_c = "--";
            end

            leg(2,i_c) = plot(ax(i), t, 3*data_sig(i,:), ...
                "DisplayName", sprintf("%s $3\\sigma$", label), ...
                "Color", colorOrder(i_c,:), ...
                "Linestyle", resLineSpecs.ls_c, ...
                "Marker", resLineSpecs.m_c, ...
                "MarkerIndices", resLineSpecs.m_offset:resLineSpecs.m_space:N_end);

            plot(ax(i), t, -3*data_sig(i,:), ...
                "DisplayName", sprintf("%s %3\\sigma$", label), ...
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
