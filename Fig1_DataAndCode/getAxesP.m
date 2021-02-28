function [hP,vP] = getAxesP(hLimits,...
    hTickLocations,...
    hLabOffset,...
    hAxisOffset,...
    hLabel,...
    vLimits,...
    vTickLocations,...
    vLabOffset,...
    vAxisOffset,...
    vLabel, plotAxes, TextLabels)
%
%
%
% Generate Axes Parameters!
%
%     hLimits,...
%     hTickLocations,...
%     hLabOffset,...
%     hAxisOffset,...
%     hLabel,...
%     vLimits,...
%     vTickLocations,...
%     vLabOffset,...
%     vAxisOffset,...
%     vLabel, 
%     plotAxes, 
%     TextLabels
tickColor = [0.4 0.4 0.4];
set(gca,'clipping','off');
if ~exist('plotAxes','var')
    plotAxes = [1 1];
    
end

if ~exist('TextLabels','var')
    TextLabels.hTick = [];
    TextLabels.hTickNames = [];
end

hP = [];
hP.axisOrientation = 'h';
hP.fontSize = 14;
if ~isempty(TextLabels.hTick)
    hP.tickLabelLocations = [hTickLocations TextLabels.hTick];
    hP.tickLocations = [hTickLocations TextLabels.hTick];
       if ~isempty(hTickLocations)
           for d = 1:length(hTickLocations)
               hP.tickLabels{d} = sprintf('%g',hTickLocations(d));
               hP.tickColor{d} = tickColor;
           end
       else
           hP.tickLabels = {};
           hP.tickColor = {};
       end
    
        for n=1:length(TextLabels.hTick)
            hP.tickLabels{end+1} = TextLabels.textLabel{n};
            hP.tickColor{end+1} = TextLabels.tickColor{n};
        end
    
else
    hP.tickLabelLocations = [hTickLocations];
    hP.tickLocations = [hTickLocations];
    for d = 1:length(hP.tickLabelLocations)
        hP.tickLabels{d} = sprintf('%g',hP.tickLabelLocations(d));
        hP.tickColor{d} = [0.8 0 0];
    end
    
end

D = abs(0.01*diff(vLimits));

hP.tickLength = D;
hP.axisLabelOffset = hLabOffset;
hP.axisOffset = hAxisOffset;
hP.axisLabel = hLabel;
hP.axesColor = 'r';
hP.fontSize = 12;
hP.tickFontSize = 12;
if plotAxes(1)
    hP = AxisMMC(hLimits(1), hLimits(2), hP);
end


% % draw Y-axes
D = abs(0.01*diff(hLimits));

vP = [];
vP.axisOrientation = 'v';
vP.axisOffset = vAxisOffset;
vP.axisLabelOffset = vLabOffset;

for d = 1:length(vTickLocations)
    vP.tickLabels{d} = sprintf('%g',vTickLocations(d));
    vP.tickColor{d} = tickColor;
end
vP.axesColor = 'r';
vP.tickLocations = vTickLocations;
vP.axisLabel = vLabel;
vP.tickLength = D;
vP.fontSize = 12;
vP.tickFontSize = 12;

if plotAxes(2)
    vP = AxisMMC(vLimits(1),vLimits(2), vP);
end
