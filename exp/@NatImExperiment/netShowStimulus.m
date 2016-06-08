function [e,retInt32,retStruct,returned] = netShowStimulus(e,params)
% Show natural, phase scrambled and whitenoise images in a sophisticated
% randomization pattern bla bla
%
% LG/GD 07/10/2013
win = get(e,'win');
refresh = get(e,'refreshRate');

% read parameters
nIm = getParam(e,'imPerTrial');
imTime = getParam(e,'imTime');
blankTime = getParam(e,'blankTime');
bgColor = getParam(e,'bgColor');
stimTime = nIm*imTime+(nIm-1)*blankTime;
postStimTime = getParam(e,'postStimulusTime');

%write delayTime
params.delayTime = stimTime+postStimTime;

% frame duration in msec ~= 10 msec
 flipInterval = 1000 / refresh; 

% show one randomly drawn sequence of nIm images
cond = getParam(e,'condition');

%return function call
tcpReturnFunctionCall(e,int32(0),params,'netShowStimulus');


startTime = GetSecs;
t = -Inf;
blank = true;
first = true;
while  t-startTime < imTime/1000
    
    % was there an abort during stimulus presentation?
    [e,abort] = tcpMiniListener(e,{'netAbortTrial','netTrialOutcome'});
    if abort
        fprintf('Abort during stimulus\n')
        break
    end
    
%     if blank && (GetSecs-t > (blankTime-flipInterval)/1000)
        % if blank is shown for blankTime - time of one frame, show image in
        % next frame
        
        Screen('DrawTexture',win,e.textures(cond),[],e.destRect);
%         blank = false;
        
        e = swap(e);
        t = getLastSwap(e);

        if first
            e = addEvent(e,'showStimulus',t);
            first = false;
        end
%         
%         subStimulusTime = getLastSwap(e);
%         e = addEvent(e,'showSubStimulus',subStimulusTime);
        
%     elseif GetSecs-t > (imTime-flipInterval)/1000
%         % if image is shown for imTime - time of one frame, show blank in next frame
% 
%         Screen('FillRect',win,bgColor,e.destRect);
%         blank = true;
%         
%         e = swap(e);
%         t = getLastSwap(e);
%         
%         cIm = cIm + 1;
%         if cIm == nIm + 1
%             endTime = getLastSwap(e);
%             e = addEvent(e,'endStimulus',endTime);
%         end
%         
%         
%     end
    
%     % wait a little to relax the cpu
%     WaitSecs(flipInterval/10000)
    
end
endTime = getLastSwap(e);
            e = addEvent(e,'endStimulus',endTime);
% WaitSecs((postStimTime-flipInterval)/1000)


% remove fixation spot
if ~abort
    e = clearScreen(e);
end


% return values
retInt32 = int32(0);
retStruct = struct;
returned = true;
