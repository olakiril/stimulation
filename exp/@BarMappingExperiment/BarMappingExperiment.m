function e = BarMappingExperiment(varargin)
% Simple moving bar stimulus

%% Copy constructor
if nargin == 1 && isa(varargin{1},'BarMappingExperiment')
    e = varargin{1};
    return
end

% otherwise 1st input argument indicates whether to prepare the experiment
% immediately (default) (i.e. open window, start tcp listener etc...)
if nargin == 1
    startNow = varargin{1};
else
    startNow = false;
end

e.pxPerDeg = [];
e.stimRect = [];

%% Create class object
e.photoDiodeTimer = PhotoDiodeTimer(200, [200 0]);
t = TrialBasedExperiment(NoRandomization,StimulationData,'photodiodeFlipColIdx',[200 0],'photodiodeSpotSize',40);
e = class(e,'BarMappingExperiment',t);

%% Prepare experiment
% -------------------------------------------------------------------------

if startNow
    e = openWindow(e);
    e = tcpMainListener(e);
end
