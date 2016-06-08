function [e,retInt32,retStruct,returned] = netStartSession(e,params)

% initialize parent
[e,retInt32,retStruct,returned] = initSession(e,params);

% set gamma calibration to original value (overwrite)
if ~params.normalizedGamma
    origGt = get(e,'origGammaTable');
    Screen('LoadNormalizedGammaTable',get(e,'win'), origGt);
end

% make the photodiode larger
e = set(e,'photoDiodeTimer',PhotoDiodeTimer(params.stimulusTime/1000*60,[0 255],50));

%%%%%%% Added 2014-09-08 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% calculate disk size in case of full-screen grating
ndx = find(params.diskSize < 0);
if ~isempty(ndx)
    rect = Screen(get(e,'win'),'Rect');
    sz = diff(reshape(rect,2,2),[],2);
    params.diskSize(ndx) = sqrt(sz'*sz) + 5;
end

% Enable alpha blending with proper blend-function. We need it for drawing
% of our alpha-mask
win = get(e,'win');
Screen('BlendFunction',win,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);

% Generate alpha masks

% determine size
e.alphaMaskSize = ceil(max(params.diskSize)/2);

nDiskSizes = numel(params.diskSize);
e.alphaMask = cell(1,nDiskSizes);
e.alphaDiskSize = zeros(1,nDiskSizes);
for i = 1:nDiskSizes
    bgColor = getSessionParam(e,'bgColor',1);
    diskSize = params.diskSize(i);
    x = -e.alphaMaskSize:e.alphaMaskSize-1;
    [X,Y] = meshgrid(x,x);
    alphaLum = repmat(permute(bgColor,[2 3 1]),2*e.alphaMaskSize,2*e.alphaMaskSize);
    alphaBlend = 255 * (sqrt(X.^2 + Y.^2) > diskSize/2);
        e.alphaMask{i} = cat(3,alphaLum,alphaBlend);
%     e.alphaMask(i) =
%     Screen('MakeTexture',win,cat(3,alphaLum,alphaBlend)); %for some
%     %strange reason building this texture beforhand fails sometimes
    e.alphaDiskSize(i) = diskSize;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%% Added 2015-01-05 to preload the movies %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% movieFile = getParam(e,'movieName');
% moviePath = getParam(e,'moviePath');
% movieNumber = params.movieNumber;
% movieStat = e.movieStat;
% 
% for imovie = movieStat
%     for inum = movieNumber
% 
%         % initialize movie
%         filename = getLocalPath(sprintf('%s%s%d_%s.avi',moviePath, ...
%                         movieFile,inum,imovie{1}));
% 
%         disp(filename)
% 
%         tic 
%         [movie, foo, foo2, imgw, imgh] = Screen('OpenMovie', win, filename);
%         toc
% 
%         eval(['e.stimInfo.' (imovie{1}) '_' num2str(inum) '.movie = movie;'])
%         eval(['e.stimInfo.' (imovie{1}) '_' num2str(inum) '.imgw = imgw;'])
%         eval(['e.stimInfo.' (imovie{1}) '_' num2str(inum) '.imgh = imgh;'])
% 
%     end
% end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%