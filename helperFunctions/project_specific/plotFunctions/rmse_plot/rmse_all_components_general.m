function [f,a] = rmse_all_components_general(data, IN_time_array, cases_plot, casePlotOpts, figurePlotOpts)

v_name = figurePlotOpts.variable_name;
f_trans = figurePlotOpts.transformation;
title_label = figurePlotOpts.title_label;
y_unit = figurePlotOpts.y_unit;

f = figure();
a = gca;
colorOrder = colororder;
Nc_max = size(colorOrder,1);
N_end = length(IN_time_array);

hold on
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
    
    
    resData = f_trans(res.(v_name));
    res1 = reshape(resData,size(resData,1),[]);

    if isfield(casePlotOpts,c)
        lineSpecs = get_ls_specs(casePlotOpts.(c));
    else
        lineSpecs = get_ls_specs(struct);
    end

    plot(IN_time_array, sqrt(mean(res1.^2,2)), ...
        "Color", colorOrder(mod1(i_c,Nc_max),:),...
        "LineStyle", lineSpecs.ls_c,....
        "DisplayName", label,...
        "Marker", lineSpecs.m_c, ...
        "MarkerIndices",lineSpecs.m_offset:lineSpecs.m_space:N_end);

end
if isfield(figurePlotOpts,"legend")
    leg_opt = figurePlotOpts.legend;
else
    leg_opt = {"Location","best","NumColumns",1, 'Interpreter',"latex"};
end
legend(leg_opt{:})
grid on
ylabel(sprintf("%s",y_unit))
xlabel("Time [s]")
if ~(isfield(figurePlotOpts,"omit_title") && figurePlotOpts.omit_title)
    title(title_label)
end


end
