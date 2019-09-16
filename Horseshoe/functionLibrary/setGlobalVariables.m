function setGlobalVariables()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% setGlobalVariables() is an empty funciton that loads all the background
% data/ camera properties. Theses functions are used by multiple functions
% hence they are global
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global gain 
global offset
global cameraParams
global sensitivityMap
global optimizer
global metric
global bitmap

[optimizer, metric] = imregconfig('monomodal');

%{
basepath = [filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive' filesep...
    'FINIS' filesep '11) Science and Post-Processing' filesep...
    'Saved parameters'];
%}
basepath = 'Saved parameters';

gain = load([basepath filesep 'Radiometric.mat'], 'gain');
gain = gain.gain;

offset = load([basepath filesep 'Radiometric.mat'], 'offset');
offset = offset.offset;

sensitivityMap = load([basepath filesep 'sensitivity.mat']);
sensitivityMap = sensitivityMap.sensitivityMap;
sensitivityMap(isnan(sensitivityMap)) = 0;

cameraParams = load([basepath filesep 'cameraParams.mat']);
cameraParams = cameraParams.cameraParams;

bitmap = isnan(offset);
