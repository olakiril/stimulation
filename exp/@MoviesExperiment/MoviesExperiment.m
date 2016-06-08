function e = MoviesExperiment(varargin)

e.movie = [];
e.frameRate = [];
e.frameSize = [];
e.movieStat = {'nat','phs','ori','obj1','obj2'};

%%% added 2014-09-08
e.alphaMask = [];
e.alphaMaskSize = [];
e.alphaDiskSize = [];
%%%%%%%%%%%%%%%%%%%%

%%% added 2015-01-05
e.stimInfo = [];
%%%%%%%%%%%%%%%%%%%%

t = TrialBasedExperiment(BlockRandomization,StimulationData);
e = class(e,'MoviesExperiment',t);

% Prepare experiment
if nargin > 0 && startNow
    e = openWindow(e);
    e = tcpMainListener(e);
end
