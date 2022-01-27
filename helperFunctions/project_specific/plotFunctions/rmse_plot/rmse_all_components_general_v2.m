function [f,a] = rmse_all_components_general_v2(data, IN_time_array, casePlotOptsTot, figurePlotOpts)

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
for i_c = 1:numel(data)
    res = data(i_c);
    casePlotOpts = casePlotOptsTot(i_c);
    resData = f_trans(res.(v_name));
    res1 = reshape(resData,size(resData,1),[]);

    if isstruct(casePlotOpts)
        lineSpecs = get_ls_specs(casePlotOpts);
    else
        lineSpecs = get_ls_specs(struct);
    end

    plot(IN_time_array, sqrt(mean(res1.^2,2)), ...
        "Color", colorOrder(mod1(i_c,Nc_max),:),...
        "LineStyle", lineSpecs.ls_c,....
        "DisplayName", res.label,...
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
