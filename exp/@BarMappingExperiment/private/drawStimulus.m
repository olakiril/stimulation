function [e,retInt32,retStruct,returned] = drawStimulus(e)

retInt32 = 0;
retStruct = struct([]);
returned = 0;

% some member variables..
win = get(e,'win');

barWidth	 	= getParam(e, 'barWidth');	% Degrees
speed            	= getParam(e,'speed');		% cycles/sec
trajectoryAngle  	= getParam(e,'trajectoryAngle'); % Degrees
postStimTime = getParam(e,'postStimulusTime');

% CONVERT TO SCREEN UNITS
screenRect = Screen('Rect', win);
frameRate = get(e, 'refreshRate');
barWidthPx = ceil(e.pxPerDeg * barWidth);
barSizePx  = [barWidthPx 2*screenRect(3)];

% determine starting position
trajectoryCenter = 0.5 * screenRect(3:4);
angle =  trajectoryAngle / 180 * pi;
% len = 2 * eccentricity * e.pxPerDeg;
len = screenRect(3) - screenRect(1);
startPos = trajectoryCenter - 0.5 * len * [cos(angle) -sin(angle)];
pos = startPos;

deg = len/e.pxPerDeg; % total degrees
delay = 1000/speed - postStimTime; % total time in miliseconds
degPerSecond = deg/delay*1000;
offsetPerFrame = degPerSecond * e.pxPerDeg / frameRate;

% How many frames do we have to precalculate?
nbFrames = ceil(len / offsetPerFrame);

texMat = 253 * ones(1, barWidthPx);
tex = Screen('MakeTexture',win,texMat);

% STIM PRESENTATION
for i=1:nbFrames
    [e,abort] = tcpMiniListener(e,{'netAbortTrial','netTrialOutcome'});
    if abort
        break
    end
    Screen('FillRect', win, 0);
    % draw colored rectangle
    rect = [pos - 0.5 * barSizePx, pos + 0.5 * barSizePx];
    Screen('DrawTexture',win,tex,[],rect,-angle*180/pi);
    e=swap(e);
    
    pos = pos + offsetPerFrame *  [cos(angle), -sin(angle)];
end


