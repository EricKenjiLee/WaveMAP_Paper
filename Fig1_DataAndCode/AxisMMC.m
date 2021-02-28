
% plots an axis / calibration
%
% usage: outParams = AxisMMC(start, fin, params)
%
% 'start' and 'fin' are the starting and ending values of the axis
% 'params' is an optional structure with one or more of the following fields
%         tickLocations    default =  [start fin]
%            tickLabels    default = {'start',  'fin'}
%    tickLabelLocations    default is the numerical values of the labels themselves
%             longTicks    default is ticks with labels are long
%           extraLength    default = 0.5500  long ticks are this proportion longer
%             axisLabel    default = '' (no label)
%            axisOffset    default = 0
%       axisOrientation    default = 'h' ('h' = horizontal, 'v' = vertical)
%                invert    default = 0
%            tickLength    default is 1/100 of total figure span
%       tickLabelOffset    default based on tickLength
%       axisLabelOffset    default based on tickLength
%         lineThickness    default = 1
%                 color    default = 'k'
%              fontSize    default = 16;
%              tickFont    default = 10;
%
% Note that you can specify all, some, or none of these, in any order
%
% 'outParams' returns the parameters used (usually some mix of supplied and default)
% This is convenient if you don't like what you see and wish to know what a good
% rough starting value is for a given field.

function outParams = AxisMMC(start, fin, varargin)

% ********* PARSE INPUTS *******************
Pfields = {}; ipf = 1; %these will collect the fieldnames
% Locations of tick marks
Pfields{ipf} = 'tickLocations'; ipf=ipf+1;
if ~isempty(varargin) && isfield(varargin{1}, 'tickLocations')
    tickLocations = varargin{1}.tickLocations;
else
    tickLocations = [start, fin];
end

% Numerical labels for the ticks
Pfields{ipf} = 'tickLabels'; ipf=ipf+1;
if ~isempty(varargin) && isfield(varargin{1}, 'tickLabels')
    tickLabels = varargin{1}.tickLabels;
    
else
    for i = 1:length(tickLocations)
        tickLabels{i} = sprintf('%g', tickLocations(i)); % defaults to values based on the tick locations
    end
    
end

% Locations of the numerical labels
Pfields{ipf} = 'tickLabelLocations'; ipf=ipf+1;
if ~isempty(varargin) && isfield(varargin{1}, 'tickLabelLocations')
    tickLabelLocations = varargin{1}.tickLabelLocations;
else
    for i = 1:length(tickLabels)
        tickLabelLocations(i) = eval(tickLabels{i}); %defaults to the values specified by the labels themselves
    end
end
if length(tickLabelLocations) ~= length(tickLabels)
    disp('ERROR, tickLabelLocations not the same length as tickLabels');
    disp('USER overridden, defaults used');
    clear tickLabelLocations;
    for i = 1:length(tickLabels)
        tickLabelLocations(i) = eval(tickLabels{i}); %defaults to the values specified by the labels themselves
    end
end

% Any long ticks
Pfields{ipf} = 'longTicks'; ipf=ipf+1;
if ~isempty(varargin) && isfield(varargin{1}, 'longTicks')
    longTicks = varargin{1}.longTicks;  % these are the locations (must be a subset of the above)
    if (min(ismember(longTicks,tickLocations))==0), disp('One or more long ticks doesnt exist'); end
else
    longTicks = tickLabelLocations;  % default is labels get long ticks
end

% Length of the long ticks
Pfields{ipf} = 'extraLength'; ipf=ipf+1;
if ~isempty(varargin) && isfield(varargin{1}, 'extraLength')
    extraLength = varargin{1}.extraLength;  % long ticks are 'extraLength' times as long as standard ticks
else
    extraLength = 0.55;
end

% axis label (e.g. 'spikes/s')
Pfields{ipf} = 'axisLabel'; ipf=ipf+1;
if ~isempty(varargin) && isfield(varargin{1}, 'axisLabel')
    axisLabel = varargin{1}.axisLabel;
else
    axisLabel = '';
end

% Axis offset (vertical for a horizontal axis, and vice versa)
Pfields{ipf} = 'axisOffset'; ipf=ipf+1;
if ~isempty(varargin) && isfield(varargin{1}, 'axisOffset')
    axisOffset = varargin{1}.axisOffset;
else
    axisOffset = 0;
end

% choose horizontal or vertical axis
Pfields{ipf} = 'axisOrientation'; ipf=ipf+1;
if ~isempty(varargin) && isfield(varargin{1}, 'axisOrientation')
    axisOrientation = varargin{1}.axisOrientation(1); % just keep the first letter ('h' for horizontal, 'v' for vertical)
else
    axisOrientation = 'h';  % horizontal is default
end
if axisOrientation == 'H', axisOrientation = 'h'; end  % accept upper or lowercase
if axisOrientation ~= 'h', axisOrientation = 'v'; end


% normal or inverted axis (inverted = top for horizontal, rhs for vertical)
Pfields{ipf} = 'invert'; ipf=ipf+1;
if ~isempty(varargin) && isfield(varargin{1}, 'invert')
    invert = varargin{1}.invert; % just keep the first letter ('h' for horizontal, 'v' for vertical)
else
    invert = 0; % default is normal axis
end

% length of ticks
Pfields{ipf} = 'tickLength'; ipf=ipf+1;
if ~isempty(varargin) && isfield(varargin{1}, 'tickLength')
    tickLength = varargin{1}.tickLength;
else
    axLim = axis;  % default values based on 'actual' axis size of figure
    if axisOrientation == 'h'
        tickLength = abs(axLim(4)-axLim(3))/100;
    else
        tickLength = abs(axLim(2)-axLim(1))/100;
    end
end
if invert == 1, tickLength = -tickLength; end  % make negative if axis is inverted

% offset of numerical tick labels from the ticks (vertical offset if using a horizontal axis)
Pfields{ipf} = 'tickLabelOffset'; ipf=ipf+1;
if ~isempty(varargin) && isfield(varargin{1}, 'tickLabelOffset')
    tickLabelOffset = varargin{1}.tickLabelOffset;
else
    tickLabelOffset = tickLength/2;
end

% offset of axis label
Pfields{ipf} = 'axisLabelOffset'; ipf=ipf+1;
if ~isempty(varargin) && isfield(varargin{1}, 'axisLabelOffset')
    axisLabelOffset = varargin{1}.axisLabelOffset;
else
    
    if axisOrientation == 'h', axisLabelOffset = tickLength*4;
    else axisLabelOffset = tickLength*4.5; end
end

% line thickness
Pfields{ipf} = 'lineThickness'; ipf=ipf+1;
if ~isempty(varargin) && isfield(varargin{1}, 'lineThickness')
    lineThickness = varargin{1}.lineThickness;
else
    lineThickness = 1; % default thickness is 1
end

% color
Pfields{ipf} = 'color'; ipf=ipf+1;
if ~isempty(varargin) && isfield(varargin{1}, 'color')
    color = varargin{1}.color;
else
    color = 'k'; % default color is black
end



Pfields{ipf} = 'tickColor'; ipf=ipf+1;
if ~isempty(varargin) && isfield(varargin{1}, 'tickColor')
    tickColor = varargin{1}.tickColor;
else
    tickColor = repmat({'k'},1,length(tickLocations)); % default color is black
end

Pfields{ipf} = 'axesColor'; ipf=ipf+1;
if ~isempty(varargin) && isfield(varargin{1}, 'axesColor')
    axesColor = varargin{1}.axesColor;
else
    axesColor = 'k'; % default color is black
end



% font size
Pfields{ipf} = 'fontSize'; ipf=ipf+1;
if ~isempty(varargin) && isfield(varargin{1}, 'fontSize')
    fontSize = varargin{1}.fontSize;
else
    fontSize = 18; % default fontsize is 8 points (numerical labels are 1 pt smaller)
end

Pfields{ipf} = 'tickFontSize'; ipf=ipf+1;
if ~isempty(varargin) && isfield(varargin{1}, 'tickFontSize')
    tickFontSize = varargin{1}.tickFontSize;
else
    tickFontSize = 16; % default fontsize is 8 points (numerical labels are 1 pt smaller)
end


% warn if there is an unrecognized field in the input parameter structure
if ~isempty(varargin)
    fnames = fieldnames(varargin{1});
    for i = 1:length(fnames)
        recognized = max(strcmp(fnames{i},Pfields));
        if recognized == 0, fprintf('fieldname %s not recognized\n',fnames{i}); end
    end
end
% ********** DONE PARSING INPUTS ***************


% DETERMINE APPOPRIATE ALIGNMENT FOR TEXT (based on axis orientation)
if axisOrientation == 'h';  % for horizontal axis
    LalignH = 'center';  % axis label alignment
    NalignH = 'center';  % numerical labels alignment
    if invert==0
        LalignV = 'top';
        NalignV = 'top';
    else
        LalignV = 'bottom';
        NalignV = 'bottom';
    end
else                        % for vertical axis
    LalignH = 'center';  % axis label alignment
    NalignV = 'middle';  % numerical labels alignment
%     NalignV = 'middle';
    
    if invert==0
        LalignV = 'bottom';  % axis label alignment
        NalignH = 'right';
    else
        LalignV = 'top';
        NalignH = 'left';
    end
end


% PLOT AXIS LINE
% plot main line with any ending ticks as part of the same line
% (looks better in illustrator that way)
axisX = [start, fin];
axisY = axisOffset * [1, 1];
if ismember(start, tickLocations)
    tempLen = tickLength + tickLength*extraLength*ismember(start, longTicks);
    axisX = [start, axisX];
    axisY = [axisY(1)-tempLen,axisY];
end
if ismember(fin, tickLocations)
    tempLen = tickLength + tickLength*extraLength*ismember(fin, longTicks);
    axisX = [axisX, fin];
    axisY = [axisY, axisY(end)-tempLen];
end
if axisOrientation == 'h', 
    h = plot(axisX, axisY); 
else
    
    h = plot(axisY, axisX); 
end
set(h,'color', color, 'lineWidth', lineThickness,'clipping','off');

% PLOT TICKS
for i = 1:length(tickLocations)
    if ~ismember(tickLocations(i),[start, fin]) % these have already been plotted
        tempLen = tickLength + tickLength*extraLength*ismember(tickLocations(i), longTicks);
        tickX =  tickLocations(i)*[1 1];
        tickY = axisOffset + [0 -tempLen];
        
        if axisOrientation == 'h', 
            hT = plot(tickX, tickY); 
        else 
            hT = plot(tickY, tickX); 
        end
        set(hT,'color', color, 'lineWidth', lineThickness,'clipping','off');
    end
end

% PLOT NUMERICAL LABELS (presumably on the ticks)
tickLim = tickLength + tickLength*extraLength*~isempty(longTicks); % longest tick length
for i = 1:length(tickLabelLocations)
    
    x = double(tickLabelLocations(i));
    y = double(axisOffset - tickLim - tickLabelOffset);
    
    if axisOrientation == 'h',
        h = text(x, y, tickLabels{i});
    else
        
        h = text(y, x, tickLabels{i});
    end
 
    set(h,'HorizontalA', NalignH, 'VerticalA', NalignV, 'color', tickColor{i}, 'FontSize',tickFontSize,'FontName','Arial', 'clipping','off');
end

% PLOT AXIS LABEL
x = (start+fin)/2;
y = axisOffset - tickLim - axisLabelOffset;
try
if axisOrientation == 'h', h = text(double(x), double(y), axisLabel); else h = text(double(y), double(x), axisLabel); end


if axisOrientation == 'v', set(h,'rotation',90); end
set(h,'HorizontalA', LalignH, 'VerticalA', LalignV, 'fontsize', fontSize, 'color', axesColor,'FontName','Arial', 'clipping','off');
catch
    
end
% DONE PLOTTING


% make outParams structure (tells user what default choices were made)
for i = 1:length(Pfields)
    outParams.(Pfields{i}) = eval(Pfields{i});
end;



