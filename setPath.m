function setPath

path = mfilename('fullpath');
folder = fileparts(path);
addpath(fullfile(folder,'exp'))

