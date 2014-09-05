function e = cleanUp(e)

% Reset gamma table
disp('Restoring gamma table')
Screen('LoadNormalizedGammaTable', get(e, 'win'), repmat(linspace(0,1,256)', 1, 3));
e.TrialBasedExperiment = cleanUp(e.TrialBasedExperiment);
