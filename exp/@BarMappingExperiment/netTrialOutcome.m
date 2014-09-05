function [e,retInt32,retStruct,returned] = netTrialOutcome(e,params)
% Get trial outcome (right or wrong response) from state system and notify it 
% whether or not the monkey should be rewarded.

% read outcome
e = clearScreen(e);

retInt32 = 0;
retStruct = struct([]);
returned = false;
