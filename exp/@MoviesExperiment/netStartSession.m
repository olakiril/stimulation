function [e,retInt32,retStruct,returned] = netStartSession(e,params)

% initialize parent
[e,retInt32,retStruct,returned] = initSession(e,params);

% set gamma calibration to original value (overwrite)
origGt = get(e,'origGammaTable');
Screen('LoadNormalizedGammaTable',get(e,'win'), origGt);

% make the photodiode larger
e = set(e,'photoDiodeTimer',PhotoDiodeTimer(params.stimulusTime/1000*60,[0 255],50));

