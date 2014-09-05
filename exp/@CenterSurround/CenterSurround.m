function e = CenterSurround(varargin)
% Multidimensional coding experiment.
% AE 2008-12-18

% Some variables we need to precompute the stimulus
e.border = [];
e.textures = [];
e.textureSize = [];
e.gammaTables = [];
e.alphaMask = [];
e.alphaMaskSize = [];
e.alphaDiskSize = [];
e.alphaBorder = [];
e.centerPhi = [];

t = TrialBasedExperiment(CenterSurroundRandomization,StimulationData);
e = class(e,'CenterSurround',t);

% Prepare experiment
if nargin > 0 && startNow
    e = openWindow(e);
    e = tcpMainListener(e);
end
