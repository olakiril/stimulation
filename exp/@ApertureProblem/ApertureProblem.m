function e = ApertureProblem(varargin)
% ApertureProblem experiment.
% MF 2015-07-23

% Some variables we need to precompute the stimulus
e.textures = [];
e.textureSize = [];
e.gammaTables = [];
e.alphaMask = [];
e.alphaMaskSize = [];
e.alphaDiskSize = [];
e.movementOri = [];

t = TrialBasedExperiment(ApertureProblemRandomization,StimulationData);
e = class(e,'ApertureProblem',t);

% Prepare experiment
if nargin > 0 && startNow
    e = openWindow(e);
    e = tcpMainListener(e);
end
