function [e,retInt32,retStruct,returned] = netShowStimulus(e,params)
% Show multidimensional oriented gratings.
%
% AE 2009-04-23

win = get(e,'win');
rect = Screen('Rect',win);
refresh = get(e,'refreshRate');

% read parameters
stimTime = getParam(e,'stimulusTime');
stimFrames = getParam(e,'stimFrames');
postStimTime = getParam(e,'postStimulusTime');

% compute number of frames
flipInterval = 1000 / refresh; % frame duration in msec ~= 10 msec
m = ceil(stimTime / flipInterval);
nFrames = ceil(m / stimFrames);

% obtain conditions to show
random = get(e,'randomization');
[conds,random] = getParams(random,nFrames);
e = set(e,'randomization',random);

% return function call
tcpReturnFunctionCall(e,int32(0),struct,'netShowStimulus');

frames = 0;
k = 0;
alphaIn = 1;
alphaOut = 1;
for i = 1:nFrames*stimFrames
    % check for abort signal
    [e,abort] = tcpMiniListener(e,{'netAbortTrial','netTrialOutcome'});
    if abort
        fprintf('stimulus was aborted.....................................\n')
        break
    end
    
    % new stimulus after n frames
    if frames == 0
        k = k + 1;
        frames = stimFrames;
        
        % new grating parameters
        location = getSessionParam(e,'location',conds(k));
        diskSize = getSessionParam(e,'diskSize',conds(k));
        spatialFreq = getSessionParam(e,'spatialFreq',conds(k));
        pxPerDeg = getPxPerDeg(getConverter(e));
        spatialFreq = spatialFreq / pxPerDeg(1);
        orientationOut = getSessionParam(e,'orientationOut',conds(k));
              orientationIn = getSessionParam(e,'orientationIn',conds(k));
        phase = getSessionParam(e,'initialPhase',conds(k));
        period = 1 / spatialFreq;
        speedP = getSessionParam(e,'speed',conds(k));    % in cycles/sec
        speed = speedP * period / refresh;               % convert to px/frame
        sspeed = speedP/refresh*(2*pi);
        sphase = phase;
        if orientationOut==-1; alphaOut = 0;end
        if orientationIn==-1; alphaIn = 0;end
    end
    
    % special params
    sinusoidal = getSessionParam(e,'sinusoidal',conds(k));
    if sinusoidal
        vgrat = 127.5 + 126.5 * sin(e.centerPhi +sphase );
    else
        vgrat = 127.5 + 126.5 * sign(sin(e.centerPhi +sphase));
    end
    e.alphaBorder(:,:,1) = repmat(vgrat,[length(vgrat), 1,1]);
    
%     % set luminance via gamma table manipulation
%     Screen('LoadNormalizedGammaTable',win,repmat(e.gammaTables(:,conds(k)),1,3),1);
    
    % move grating
    u = mod(phase,period) - period/2;
    xInc = -u * sin(orientationOut/180*pi);
    yInc = u * cos(orientationOut/180*pi);
    ts = e.textureSize(conds(k));
    centerX = mean(rect([1 3])) + location(1);
    centerY = mean(rect([2 4])) + location(2);
    destRect = [centerX centerY centerX centerY] + [-ts -ts ts ts] / 2 ...
        + [xInc yInc xInc yInc];
    
    % draw grating
    Screen('DrawTexture',win,e.textures(conds(k)),[],destRect,orientationOut+90,[],alphaOut);
    
    % draw circular aperture
    alphaRect = [centerX centerY centerX centerY] + [-1 -1 1 1] * e.alphaMaskSize;
    Screen('DrawTexture',win,e.alphaMask(e.alphaDiskSize == diskSize),[],alphaRect,orientationOut+90);
    
    % draw internal circular aperture
    Screen('DrawTexture',win,e.border)
    
    % rotate co-ordinate system
    textW = Screen('MakeTexture',win,e.alphaBorder);
    ts = size(e.alphaBorder,1);
    destRect = [centerX centerY centerX centerY] + [-ts -ts ts ts] / 2;
    Screen('DrawTexture',win,textW,[],destRect,orientationIn+270,[],alphaIn)
    
    % fixation spot
    drawFixSpot(e);
    e = swap(e);
    
    % compute startTime
    if i == 1
        startTime = getLastSwap(e);
        e = addEvent(e,'showStimulus',startTime);
    end
    
    % log event for each new stimulus
    if frames == stimFrames
        e = addEvent(e,'showSubStimulus',getLastSwap(e));
    end
    
    frames = frames - 1;
    phase = phase + speed;
    sphase = sphase + sspeed;
    Screen('Close',textW)
end

% keep fixation spot after stimulus turns off
if ~abort
    
    drawFixSpot(e);
    e = swap(e);
    
    % log stimulus offset event
    e = addEvent(e,'endStimulus',getLastSwap(e));
    
    while (GetSecs-startTime)*1000 < (stimTime + postStimTime);
        % check for abort signal
        [e,abort] = tcpMiniListener(e,{'netAbortTrial','netTrialOutcome'});
        if abort
            break
        end
    end
    
    if ~abort
        e = clearScreen(e);
    end
else
    % log stimulus offset event
    e = addEvent(e,'endStimulus',getLastSwap(e));
end

% store shown stimuli
e = setTrialParam(e,'conditions',conds(1:k));

% return values
retInt32 = int32(0);
retStruct = struct;
returned = true;

