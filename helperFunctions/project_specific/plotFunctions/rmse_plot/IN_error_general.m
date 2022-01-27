function [f, ax] = IN_error_general(data, IN_time_array, cases_plot, casePlotOpts, figurePlotOpts)

v_name = figurePlotOpts.variable_name;
f_trans = figurePlotOpts.transformation;
title_label = figurePlotOpts.title_label;
y_unit = figurePlotOpts.y_unit;

f = figure();
colorOrder = colororder;
ax = zeros(3,1);
dirs = ["x", "y","z"];
for i = 1:3
    ax(i) = subplot(3,1,i);
    hold on
    leg = nan(size(cases_plot,1),1);
    for i_c = 1:size(cases_plot,1)
        case_path = cases_plot(i_c, :);
        c = case_path(end);
        path_struct_i = case_path;
        path_struct_i_label = [case_path(1), "label"];
        try 
            path_struct_i_struct = num2cell(path_struct_i);
            res = getfield(data, path_struct_i_struct{:});
            
            path_struct_i_label_struct = num2cell(path_struct_i_label);
            label_1 = getfield(data, path_struct_i_label_struct{:});
            label_2 = res.("label");
            label = label_2 + newline + label_1;
        catch ME
            warning("%s is not in %s",c, join([path_struct_i_struct{:}],"/"))
            continue
        end

        if isfield(casePlotOpts,c)
            resLineSpecs = get_ls_specs(casePlotOpts.(c));
        else
            resLineSpecs = get_ls_specs(struct);
        end
        resData = f_trans(res.(v_name));
        temp = plot(IN_time_array, squeeze(resData(:,i,:)), ...
            "Color", colorOrder(i_c,:),...
            "LineStyle",resLineSpecs.ls_c,....
            "DisplayName", label);
        leg(i_c) = temp(1);
    end
    grid on
    legend(reshape(leg(~isnan(leg)),[],1),"Location","best", "Interpreter","latex")
    ylabel(sprintf("%s %s", dirs(i),y_unit))
    xlabel("Time [s]")
    title(title_label)

end

end
