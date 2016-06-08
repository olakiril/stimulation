function [e,retInt32,retStruct,returned] = drawStimulus(e)

retInt32 = 0;
retStruct = struct([]);
returned = 0;
reduceFactor = 7; % for cpu/ram compatibility. default:7

% some member variables..
win = get(e,'win');

BarAng	 	= getParam(e, 'barWidth');	% Degrees
SqAng	 	= getParam(e, 'gridWidth');	% Degrees
BarDegreesPerSec            	= getParam(e,'speed');		%  Bar speed in °/s
GridCyclesPerSecond = getParam(e,'FlashSpeed'); % cycles/sec temporal frequency of the grid flickering
x0 = getParam(e,'monitorDistance');
monSize = getParam(e,'monitorSize');
axis = getParam(e,'Axis');
grating = getParam(e,'Grating');
gratSize = getParam(e,'GratingWidth'); % in cycles/deg
gratSpeed = getParam(e,'GratingSpeed'); % in cycles/sec

% CONVERT TO SCREEN UNITS
screenRect = Screen('Rect', win);
frameRate = get(e, 'refreshRate');

% setup parameters
xmonsize = monSize(1);% mm X monitor size
ymonsize = monSize(2);% mm Y monitor size
ny = screenRect(4) - screenRect(2); % Y axis resolution for the image space
nz = screenRect(3) - screenRect(1);% X axis resolution for the image space

% calculatestaff
FoV = atand(monSize(axis)/2/x0)*2;
GridCyclesPerRadiant = 180/SqAng/pi/2; % spatial frequency of the grid in cycles per radiant
BarCyclesPerRadiant = 180/BarAng/pi/2; % spatial frequency of the bar in cycles per radiant
BarCyclesPerSecond = BarDegreesPerSec/FoV; % convert to cycles per second.
BarOffsetCyclesPerFrame = BarCyclesPerSecond / frameRate;
GridOffsetCyclesPerFrame = GridCyclesPerSecond / frameRate;
GratOffsetCyclesPerFrame = gratSpeed/frameRate;

% initialize vectors
y = linspace(-(ymonsize/2),ymonsize/2,ny/reduceFactor);
z = linspace(-(xmonsize/2),xmonsize/2,nz/reduceFactor);
[Y,Z] = ndgrid(y,z);

% create tranformations of space
theta = pi/2-acos(Y./sqrt(x0^2+Y.^2+Z.^2)); % vertical
phi = atan(-Z/x0); % horizontal

% create grid
VG1 = (cos(2*pi*GridCyclesPerRadiant*(theta)))>0; % vertical grading
VG2 = (cos((2*pi*GridCyclesPerRadiant*(theta))-pi))>0; % vertical grading with pi offset
HG = cos(2*pi*GridCyclesPerRadiant*phi)>0; % horizontal grading
Grid = bsxfun(@times,VG1,HG) + bsxfun(@times,VG2,1-HG); %combine all

% How many frames do we have to precalculate?
delay = getParam(e,'delayTime');
nbFrames = ceil(delay/1000*frameRate);

% angle
if axis==1;angle1 = phi; angle2 = theta;else angle1 = theta;angle2 = phi;end

% intialize offsets
BarOffset = 0;
GridOffset = 0;
GratOffset = 0;

barHalfWidth = pi/2; 
BarOffsetCyclesPerFrame = BarOffsetCyclesPerFrame*FoV/BarAng/2;

% fix this
op =  sign(randn);

e = setTrialParam(e,'gratDir',op);
startOffset = min(angle1(:)*BarCyclesPerRadiant) - 1/4;
    
% STIM PRESENTATION
for i=1:nbFrames
    [e,abort] = tcpMiniListener(e,{'netAbortTrial','netTrialOutcome'});
    if abort
        break
    end

    angle = 2*pi*(angle1*BarCyclesPerRadiant+BarOffset+startOffset);
    angle(angle<(-barHalfWidth) | angle>(barHalfWidth)) = pi; % threshold grading to create a single bar
    A = cos(angle)>0; % squaring
    
    if grating
        gred = (cos(2*pi*(gratSize*(angle2)+GratOffset*op)))>0; % vertical grading
        texMat = uint8(A.*abs(gred)*254);
    else
        flash = cos(2*pi*GridOffset)>0;
        texMat =  uint8(A.*abs(Grid-flash)*254);
    end
    
    tex = Screen('MakeTexture',win,texMat);
    Screen('DrawTexture',win,tex,[],screenRect);
    
    e=swap(e);
    
    GratOffset = GratOffset+ GratOffsetCyclesPerFrame;
    GridOffset = GridOffset+ GridOffsetCyclesPerFrame;
    BarOffset = BarOffset+BarOffsetCyclesPerFrame;
    Screen('Close',tex);
end


