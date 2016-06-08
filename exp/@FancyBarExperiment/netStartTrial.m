function [e,retInt32,retStruct,returned] = netStartTrial(e,params)

% call parent's netStartTrial
[e,retInt32,retStruct,returned] = initTrial(e,params);

% randomize orientations (this should probably change...)
% compute post-stimulus fixation time
postStimTime = getParam(e,'postStimulusTime');
speed = getParam(e,'speed');
x0 = getParam(e,'monitorDistance');
monSize = getParam(e,'monitorSize');
axis = getParam(e,'Axis');
BarAng = getParam(e, 'barWidth');	% Degrees

stimulusTime = (atand(monSize(axis)/2/x0)*2 + BarAng)/speed*1000 - postStimTime; % in miliseconds
retStruct.delayTime = stimulusTime + postStimTime;
e = setTrialParam(e,'delayTime',retStruct.delayTime);
e = setTrialParam(e,'stimulusTime',stimulusTime);