function [e,retInt32,retStruct,returned] = netStartTrial(e,params)

% call parent's netStartTrial
[e,retInt32,retStruct,returned] = initTrial(e,params);

% randomize orientations (this should probably change...)
% compute post-stimulus fixation time
postStimTime = getParam(e,'postStimulusTime');
speed = getParam(e,'speed');

stimulusTime = 1000/speed - postStimTime; % in miliseconds

retStruct.delayTime = stimulusTime + postStimTime;
e = setTrialParam(e,'delayTime',retStruct.delayTime);
e = setTrialParam(e,'stimulusTime',stimulusTime);