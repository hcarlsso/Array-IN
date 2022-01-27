%% 
% we set the units of the measures used through the file
%
% [ inches | centimeters | normalized | points | {pixels} | characters ]
set(gcf, 'Units', 'inches'); 


% we set the position and dimension of the figure ON THE SCREEN
%
% NOTE: measurement units refer to the previous settings!
afFigurePosition = [0 0 3.5 2.5];         % [pos_x pos_y width_x width_y]
set(gcf, 'Position', afFigurePosition);  % [left bottom width height]

% we link the dimension of the figure ON THE PAPER in such a way that
% it is equal to the dimension on the screen
%
% ATTENTION: if PaperPositionMode is not 'auto' the saved file
% could have different dimensions from the one shown on the screen!
set(gcf, 'PaperPositionMode', 'auto');


% in order to make matlab to do not "cut" latex-interpreted axes labels
% set(gca, 'Units',				'normalized',	...	%
% 		 'Position',			[0.15 0.2 0.75 0.7]);


% we set the plots properties
%
% notes:
% - each property is actually an array of properties;
%
% line styles:  [{-} | -- | : | -.]
% marker types: [+ | o | * | . | x | square | diamond | > | ...
%                ... < | ^ | v | pentagram | hexagram | {none}]
%
% -- lines
afPlotLineWidth         = [1.3, 1.3];
astrPlotLineStyle       = [{'-'}, {':'}]; % NOTE: do not insert '.-' but '-.'
% aafPlotLineColor        = [[0.1 0.1 0.1] ; [0.2 0.2 0.2]]; % RGB

aafPlotLineColor = colororder;
%
% -- markers
aiPlotMarkerSize        = [6]; % in points
astrPlotMarkerType      = [{'none'}, {'x'}, {'o'}, {'*'},{"s"}];

PlotLineColor = struct;
PlotLineColor.accelerometer_array_2nd_order = aafPlotLineColor(1,:);
PlotLineColor.accelerometer_array_1st_order = aafPlotLineColor(2,:);
PlotLineColor.gyroscope_2nd_order = aafPlotLineColor(3,:);
PlotLineColor.gyroscope_1st_order = aafPlotLineColor(4,:);

astrArrayOfLabels       = [{"2nd order accelerometer array"}; 
    {"1st order accelerometer array"}; 
    {"2nd order gyroscope"};
    {"1st order gyroscope"}];
