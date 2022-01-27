
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
astrPlotLineStyle       = [{'-'}, {'--'}]; % NOTE: do not insert '.-' but '-.'
% aafPlotLineColor        = [[0.1 0.1 0.1] ; [0.2 0.2 0.2]]; % RGB

aafPlotLineColor = colororder;
%
% -- markers
aiPlotMarkerSize        = [6]; % in points
astrPlotMarkerType      = [{'none'}, {'x'}, {'o'}, {'*'},{"s"}];

