function [f,ax] = plot_rotation_matrix(dataTot, t, cases_plot, caseOpt)

    N_end = length(t);
    colorOrder = colororder;


    f = figure();
    ax = zeros(3,3);
    for i_c = 1:length(cases_plot)
        c = cases_plot(i_c);
        res = dataTot.(c);
        R = dataTot.(c).filt.R;
        R_vec = reshape(R,9,[]);

        if isfield(caseOpt,c) && isfield(caseOpt.(c),"mean")
            resLineSpecs = get_ls_specs(caseOpt.(c).mean);
        else
            resLineSpecs = get_ls_specs(struct);
        end

        for i = 1:9
            ax(i) = subplot(3,3,i); hold on;
            plot(t, R_vec(i,:), ...
                 "DisplayName", res.label, ...
                 "Color", colorOrder(i_c,:), ...
                 "Linestyle", resLineSpecs.ls_c, ...
                 "Marker", resLineSpecs.m_c, ...
                 "MarkerIndices", resLineSpecs.m_offset:resLineSpecs.m_space:N_end);
            grid on
        end

    end

end
