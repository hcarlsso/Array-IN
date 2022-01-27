function [f,ax] = rmse_components_general(data, IN_time_array, cases_plot, casePlotOpts, figurePlotOpts)

v_name = figurePlotOpts.variable_name;
f_trans = figurePlotOpts.transformation;
title_label = figurePlotOpts.title_label;
y_unit = figurePlotOpts.y_unit;

f = figure();
dirs = ["x", "y", "z"];
colorOrder = colororder;
N_end = length(IN_time_array);
ax = zeros(3,1);
for i = 1:3
    ax(i) = subplot(3,1,i);
    hold on
    for i_c = 1:length(cases_plot)
        c = cases_plot(i_c);
        res = data.(c);

        if isfield(casePlotOpts,c)
            lineSpecs = get_ls_specs(casePlotOpts.(c));
        else
            lineSpecs = get_ls_specs(struct);
        end
        resData = f_trans(res.(v_name));
        plot(IN_time_array, sqrt(mean(squeeze(resData(:,i,:)).^2,2)), ...
            "Color", colorOrder(i_c,:),...
            "LineStyle", lineSpecs.ls_c,...
            "DisplayName", res.label,...
            "Marker", lineSpecs.m_c, ...
            "MarkerIndices",lineSpecs.m_offset:lineSpecs.m_space:N_end);
    end
    legend("Location", "best", "Interpreter","latex")
    grid on
    ylabel(sprintf("%s %s", dirs(i),y_unit))
    xlabel("Time [s]")
    title(title_label)

end

end
