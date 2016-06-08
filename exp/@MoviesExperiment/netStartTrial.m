function [e,retInt32,retStruct,returned] = netStartTrial(e,params)
% Initialize trial.
tic
% initilialize parent
[e,retInt32,retStruct,returned] = initTrial(e,params);

% compute post-stimulus fixation time
postStimTime = getParam(e,'postStimulusTime');
stimTime = getParam(e,'stimulusTime');
retStruct.delayTime = stimTime + postStimTime;
e = setTrialParam(e,'delayTime',retStruct.delayTime);

movieFile = getParam(e,'movieName');
moviePath = getParam(e,'moviePath');
movieNumber = getParam(e,'movieNumber');
movieStat = e.movieStat{getParam(e,'movieStat')};
trTrigger = getParam(e,'trialTrigger');
% display(num2str(trTrigger))
retStruct.trialTrigger = trTrigger;

%%%% Added 2014-09-08 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
diskSize = getParam(e,'diskSize');
retStruct.diskSize = diskSize;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize movie
win = get(e,'win');
if strcmp(movieFile,'noiseMap')
    filename = getLocalPath(sprintf('%s%s%d.avi',moviePath, ...
                movieFile,movieNumber));
elseif strcmp(movieFile,'movies3D')
         filename = getLocalPath(sprintf('%s%s_%04d.avi',moviePath, ...
                movieStat,movieNumber));
else
     filename = getLocalPath(sprintf('%s%s%d_%s.avi',moviePath, ...
                    movieFile,movieNumber,movieStat));
end

disp(filename)
e = setTrialParam(e,'filename',filename);
            
toc
[movie, movieduration, fps, imgw, imgh] = Screen('OpenMovie', win, filename);


% 
% imgw = eval(['e.stimInfo.' movieStat '_' num2str(movieNumber) '.imgw']);
% imgh = eval(['e.stimInfo.' movieStat '_' num2str(movieNumber) '.imgh']);
% movie = eval(['e.stimInfo.' movieStat '_' num2str(movieNumber) '.movie']);

e.frameSize = [imgw imgh];
e.movie = movie;

% fprintf('Movie: %s%s\n', ...
%               num2str(movieNumber),movieStat);
          
          
%                     
% 
% fprintf('Movie: %s  : %u sec, %u fps, w x h = %i x %i...\n', ...
%               movieFile, movieduration, fps, imgw, imgh);
%                     

