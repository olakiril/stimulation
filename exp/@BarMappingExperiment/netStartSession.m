function [e,retInt32,retStruct,returned] = netStartSession(e,params)
% Initialize experiment.
% MF 2012-10-05

% Add constants to session params
if ~isfield(params, 'bgColor')
    params.bgColor = 0;
end

% Use the session parameters to calculate some helper constants
w = get(e, 'win');

scrRect = Screen('Rect',w);
ResX = scrRect(3) - scrRect(1);
ResY = scrRect(4) - scrRect(2);
params.monitorCenter = round([ResX ResY]'/2);

% First thing, call parent initialization, which creates the
% params structure correctly
[e,retInt32,retStruct,returned] = initSession(e,params);

screenWidth = getSessionParam(e, 'monitorSize', 1);
screenDist  = getSessionParam(e, 'monitorDistance', 1);

pxPerCm  = ResX / screenWidth(1);
cmPerDeg = 2 * tan(0.5 / 180 * pi) * screenDist;    % 1 deg in cm on the screen
e.pxPerDeg = pxPerCm * cmPerDeg;
