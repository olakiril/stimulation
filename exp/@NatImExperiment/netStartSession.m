function [e,retInt32,retStruct,returned] = netStartSession(e,params)

location = params.stimulusLocation;

% Enable alpha blending with proper blend-function. We need it
% for drawing of our alpha-mask (gaussian aperture)
win = get(e,'win');

nIm = params.imageNum; % total images shown

nFirst = params.firstTexNumber; %first texture to pick from texture struc.
nLast = nFirst + nIm  - 1; %last texture to pick from texture struc.
params.lastTexNumber = nLast;

%load texture structure
% file=sprintf('/media/atlab/fast/NatImages/imageDatabase_iml_2015-02-11.mat');
file=sprintf('/media/atlab/fast/NatImages/imageDatabase_NatPhs.mat');
f = load(file);
params.sourcefile = file; 

%create textures
e.textures = zeros(nIm,1);
% sm = ones(scFactor); %for scaling the pixels by scFactor
for i = 1:(nLast - nFirst + 1)
    j = i + nFirst - 1;
    params.source{i} = f.imageDatabase(j).filename;
    e.textures(i)= Screen('MakeTexture',win,f.imageDatabase(j).image); 
end

% define stimulus position
e.textureSize = size(f.imageDatabase(1).image); 
rect = Screen(get(e,'win'),'Rect');
scFactor = min([ e.textureSize(1)\rect(4) e.textureSize(2)\rect(3) ]);
centerX = mean(rect([1 3])) + location(1);
centerY = mean(rect([2 4])) + location(2);
e.destRect = [-e.textureSize(2) -e.textureSize(1) e.textureSize(2) e.textureSize(1)]*scFactor / 2 ...
        + [centerX centerY centerX centerY];

% initialize parent
[e,retInt32,retStruct,returned] = initSession(e,params);

% set gamma calibration to original value (overwrite)
% origGt = get(e,'origGammaTable');
% Screen('LoadNormalizedGammaTable',get(e,'win'), origGt);

% make the photodiode larger
e = set(e,'photoDiodeTimer',PhotoDiodeTimer((params.imTime+params.postStimulusTime)/1000*60,[0 255],50));
