function [e,retInt32,retStruct,returned] = netShowStimulus(e, params)
% Show orientation gratings.

e = setParams(e,params);

%% For stimulus, this must be before the loop, to make sure this function
% call does not block LabView
returned = true;
retInt32 = GetSecs;
retStruct = struct;
e = tcpReturnFunctionCall(e,retInt32,retStruct);
e = drawStimulus(e);

% clear screen
e = clearScreen(e);

