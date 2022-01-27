
pathScript = fileparts(mfilename('fullpath'))
load(fullfile(pathScript,"data.mat"))


line_settings

% we want to plot several curves
hold on;
%
% here you can plot several plots (each can have its properties)
% note: it is convenient to store the handles to the single plots
% in order to easily manage legends
%
handleToPlot1 = plot(                               ...
    res_roll_2_500Hz_time,                                           ...
    resRmseRoll2Cond.coarse.accelerometer_array_2nd_order,                                           ...
    'LineStyle',       astrPlotLineStyle{1},        ...
    'LineWidth',       afPlotLineWidth(1),          ...
    'Color',           aafPlotLineColor(1,:),       ...
    'Marker',          astrPlotMarkerType{2},       ...
    'MarkerSize',      aiPlotMarkerSize(1),...
    "MarkerIndices",   1:250:2500);
%
handleToPlot2 = plot(                               ...
    res_roll_2_500Hz_time,                                           ...
    resRmseRoll2Cond.coarse.accelerometer_array_1st_order,                                           ...
    'LineStyle',       astrPlotLineStyle{1},        ...
    'LineWidth',       afPlotLineWidth(1),          ...
    'Color',           aafPlotLineColor(2,:),       ...
    'Marker',          astrPlotMarkerType{3},       ...
    'MarkerSize',      aiPlotMarkerSize(1),...
    "MarkerIndices",   50:250:2500);

handleToPlot3 = plot(                               ...
    res_roll_2_500Hz_time,                                           ...
    resRmseRoll2Cond.coarse.gyroscope_2nd_order,                                           ...
    'LineStyle',       astrPlotLineStyle{1},        ...
    'LineWidth',       afPlotLineWidth(1),          ...
    'Color',           aafPlotLineColor(3,:),       ...
    'Marker',          astrPlotMarkerType{4},       ...
    'MarkerSize',      aiPlotMarkerSize(1),...
    "MarkerIndices",   100:250:2500);

handleToPlot4 = plot(                               ...
    res_roll_2_500Hz_time,                                           ...
    resRmseRoll2Cond.coarse.gyroscope_1st_order,                                           ...
    'LineStyle',       astrPlotLineStyle{1},        ...
    'LineWidth',       afPlotLineWidth(1),          ...
    'Color',           aafPlotLineColor(4,:),       ...
    'Marker',          astrPlotMarkerType{5},       ...
    'MarkerSize',      aiPlotMarkerSize(1),...
    "MarkerIndices",   150:250:2500);


% we set the legend properties; note:
%
%
% Locations could be [N S E W {NE} NW SE SW NO SO EO WO NEO NWO SEO SWO B BO]
% where the characters have the following meanings:
% - N = North
% - S = South
% - E = East
% - W = West
% - O = Outside the plot
% - B = Best (least conflict with data in plot)
% OR you can also specify an 1-by-4 position vector ([left bottom width height])
%
%
% The following properties are inherited when specified in "set(gca, ...)":
% - FontName
% - FontSize
% - FontUnits
% - FontWeight
% - FontAngle
% - LineWidth
%


% general properties
iFontSize           = 8;
strFontUnit         = 'points'; % [{points} | normalized | inches | centimeters | pixels]
strFontName         = 'Times';  % [Times | Courier | ]              TODO complete the list
strFontWeight       = 'normal'; % [light | {normal} | demi | bold]
strFontAngle        = 'normal'; % [{normal} | italic | oblique]     ps: only for axes 
strInterpreter      = 'latex';  % [{tex} | latex]
fLineWidth          = 1.3;      % width of the line of the axes


% note: it is quite difficult to use the "latex" interpreter for the ticks;
% if absolutely needed google for "format_ticks.m" by Alexander Hayes
set(gca,                                     ...
... 'Position',             [1 1 20 10],     ... TODO
... 'OuterPosition',        [1 1 20 10],     ... TODO
    ...
    'XGrid',                'on',            ... [on | {off}]
    'YGrid',                'on',            ... [on | {off}]
    'GridLineStyle',        '-',             ... [- | -- | {:} | -. | none]
    'XMinorGrid',           'off' ,          ... [on | {off}]
    'YMinorGrid',           'off',           ... [on | {off}]
    'MinorGridLineStyle',   ':',             ... [- | -- | {:} | -. | none]
    ...
    'XTick',                0:1:5,        ... ticks of x axis
    'YTick',                0:0.2:2,          ... ticks of y axis
    'XMinorTick',           'off' ,          ... [on | {off}]
    'YMinorTick',           'off',           ... [on | {off}]
    'TickDir',              'out',           ... [{in} | out] inside or outside (for 2D)
    'TickLength',           [.02 .02],       ... length of the ticks
    ...
    'XColor',               [.1 .1 .1],      ... color of x axis
    'YColor',               [.1 .1 .1],      ... color of y axis
    'XAxisLocation',        'bottom',        ... where labels have to be printed [top | {bottom}]
    'YAxisLocation',        'left',          ... where labels have to be printed [left | {right}]
    'XDir',                 'normal',        ... axis increasement direction [{normal} | reverse]
    'YDir',                 'normal',        ... axis increasement direction [{normal} | reverse]
    ...
    'FontName',             strFontName,     ... kind of fonts of labels
    'FontSize',             iFontSize,       ... size of fonts of labels
    'FontUnits',            strFontUnit,     ... units of the size of fonts
    'FontWeight',           strFontWeight,   ... weight of fonts of labels
    'FontAngle',            strFontAngle,    ... inclination of fonts of labels
    ...
    'LineWidth',            fLineWidth);     %   width of the line of the axes


% fonts properties
% iFontSize      = 10;
strFontUnit    = 'points'; % [{points} | normalized | inches | centimeters | pixels]
strFontName    = 'Times';  % [Times | Courier | ]                 TODO complete the list
strFontWeight  = 'bold'; % [light | {normal} | demi | bold]
strFontAngle   = 'normal'; % [{normal} | italic | oblique]     ps: only for axes 
strInterpreter = 'latex';  % [{tex} | latex]
%
strXLabel      = 'Time [s]';
strYLabel      = '[m]';
%
fXLabelRotation = 0.0;
fYLabelRotation = 90.0;



xlabel( strXLabel,                       ...
        'FontName',     strFontName,     ...
        'FontUnit',     strFontUnit,     ...
        'FontSize',     iFontSize,       ...
        'FontWeight',   strFontWeight,   ...
        'Interpreter',  strInterpreter);
%
ylabel( strYLabel,                       ...
        'FontName',     strFontName,     ...
        'FontUnit',     strFontUnit,     ...
        'FontSize',     iFontSize,       ...
        'FontWeight',   strFontWeight,   ...
        'Interpreter',  strInterpreter);
%
set(get(gca, 'XLabel'), 'Rotation', fXLabelRotation);
set(get(gca, 'YLabel'), 'Rotation', fYLabelRotation);



% in order to make matlab to do not "cut" latex-interpreted axes labels
set(gca, 'Units',    'normalized', ...
         'Position', [0.15 0.2 0.75 0.7]);

atArrayOfHandlesToLines = [handleToPlot1; handleToPlot2; handleToPlot3; handleToPlot4];
% astrArrayOfLabels       = [{"Accelerometer array 2nd"}; 
%     {"Accelerometer array 1st"}; 
%     {"Gyroscope 2nd"};
%     {"Gyroscope 1st"}];
%
strLegendLocation       = 'NW';     % combinations of N S E W B O or a vector
strLegendOrientation    = 'vertical'; % [{vertical} horizontal]
%
afEdgeColor             = [0.0 0.0 0.0]; % RGB
afTextColor             = [0.0 0.0 0.0]; % RGB
%
strInterpreter          = 'latex';    % [{tex} | latex | none]
%
%
legend( atArrayOfHandlesToLines,                     ...
        astrArrayOfLabels,                           ...
        'Location',           strLegendLocation,     ...
        'Orientation',        strLegendOrientation,  ...
        'Box',                'on',                 ... [{on} off]
        'Color',              'w',                ... none => transparent
        'EdgeColor',          afEdgeColor,           ... 
        'TextColor',          afTextColor,           ... 
        'Interpreter',        strInterpreter);
     
 % here we select which output file extension we want
bPrintOnFile_Pdf    = 1; % [0 (false)   1 (true)]
bPrintOnFile_Eps    = 1; % [0 (false)   1 (true)]


% we select the file path
%
% NOTE: do NOT insert extensions!
%strFilePath = '../images/my_figure';
strFilePath = 'exp_high_dyn_high_Fs';


% we select the printing resolution
iResolution = 600;


% we select to crop or not the figure
bCropTheFigure = 1; % [0 (false)   1 (true)]


% ATTENTION: if PaperPositionMode is not 'auto' the saved file
% could have different dimensions from the one shown on the screen!
set(gcf, 'PaperPositionMode', 'auto');        


% saving on file: requires some checks
if( bPrintOnFile_Pdf || bPrintOnFile_Eps )
    %
    % NOTE: if you want a .pdf with encapsulated fonts you need to save an
    % .eps and then convert it => it is always necessary to produce the .eps
    %
    % if we want to crop the figure we do it
    if( bCropTheFigure )
        print('-depsc2', sprintf('-r%d', iResolution), strcat(strFilePath, '.eps'));
        print('-depsc2', sprintf('-r%d', iResolution), ...
            fullfile("/home/hakcar/phd/Array-INS-2/paper/IEEEtran/figs",strcat(strFilePath, '.eps')));
      
    else
        print('-depsc2', '-loose', sprintf('-r%d', iResolution), strcat(strFilePath, '.eps'));
    end
    %
    % if we want the .pdf we produce it
    if( bPrintOnFile_Pdf )
        %
        % here we convert the .eps encapsulating the fonts
        system(                                                                    ...
          sprintf(                                                                 ...
            'epstopdf --gsopt=-dPDFSETTINGS=/prepress --outfile=%s.pdf  %s.eps',   ...
            strFilePath,                                                           ...
            strFilePath));
        %
    end
    %
    % if we do not want the .eps we remove it
    if( ~bPrintOnFile_Eps )
        delete(sprintf('%s.eps', strFilePath));
    end
    %
end% saving on file
