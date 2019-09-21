%% Function to do flat field calibration of FINIS instrument

% Set machine-specific paths
addpath(genpath('..'));
global google_drive_path
global external_drive_path
global output_drive_path
SetLocalPaths();
% End machine-specific paths

filename = 'MethaneTest2_061019_padded';
showFig = 0;

%Calculate Flat_Field parameters 
[gain, offset] = Flat_Field_Calibration(filename, showFig);

%Calculate Sensitivity Map
sensitivityMap = Generate_Sensitivity_Map(filename, gain, offset, showFig);

% Set save directory to be in ImageCalibration in Google Drive
save_path = [output_drive_path filesep '11) Science and Post-Processing' filesep 'ImageCalibration'];

save([save_path filesep 'Radiometric'], 'gain', 'offset');
save([save_path filesep 'sensitivity'], 'sensitivityMap');