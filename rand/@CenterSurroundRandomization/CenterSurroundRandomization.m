function r = CenterSurroundRandomization
% Randomization for multidimensional coding stimulus
% AE 2008-12-18

% block randomization to create all combinations of parameters
r.block = BlockRandomization('orientationOut','orientationIn', ...
    'contrast','diskSize');

% white noise randomization to determine which conditions to show in each
% frame
r.white = WhiteNoiseRandomization;

r = class(r,'CenterSurroundRandomization');
