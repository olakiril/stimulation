function r = ApertureProblemRandomization
% Randomization for Aperture Problem stimulus
% MF 2015-07-23

% block randomization to create all combinations of parameters
r.block = BlockRandomization('orientation','spatialFreq', ...
    'contrast','speed','initialPhase','movementOri');

% white noise randomization to determine which conditions to show in each
% frame
r.white = WhiteNoiseRandomization;

r = class(r,'ApertureProblemRandomization');
