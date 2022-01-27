function [fig] = plot_variances(S)
%PLOT_VARIANCES Summary of this function goes here
%   Detailed explanation goes here

cases = ["R_std_deg", "w_std_deg", "p_std", "v_std", "b_a_std", "b_g_std_deg"];
ylabels = ["[deg]", "[deg/s]", "[m]", "[m/s]","[m/s]","[m/s^2]","[deg/s]"];
titles = ["Rotation", "Angular Velocity", "Position", "Velocity", "Bias Acc.", "Bias Gyro"];

dirs = ["x","y","z"];
Markers = ["x", "o", "+", "s"];
colorOrder = colororder;
for i = 1:length(cases)
    c = cases(i);
    if isfield(S,c)
        fig = figure();
        hold on ;
        data = S.(c);
        if size(data,1) > 3
            for j = 1:3
                data_j = data(j:3:end,:);
                N = size(data_j,2);
                offset = 3;
                spacing = 10;
                for l = 1:size(data_j)
                    
                    plot(data_j(l,:), ...
                        "DisplayName",sprintf("%d  %s", l,dirs(j)), ...
                        "LineStyle","-", ...
                        "Color", colorOrder(j,:),...
                        "Marker",Markers(l),...
                        "MarkerIndices", l*offset:spacing:N)
                end
            end
        else
            for j = 1:3
                plot(data(j,:), "DisplayName", dirs(j))
            end
        end

        grid on
        ylabel(ylabels(i));
        title(sprintf("%s sigma %s", S.label , titles(i)));
        if abs(data) > 1e-16
            set(gca, "YScale", "log")
        end
        set(gca, "XScale", "log")
        xlabel("Time step []")
        legend("Location","bestoutside")
            
    else
        continue
    end
end

