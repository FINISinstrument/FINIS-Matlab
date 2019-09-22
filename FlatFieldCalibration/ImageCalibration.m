%% Function to do flat field calibration of FINIS instrument

% Set machine-specific paths
addpath(genpath('..'));
global google_drive_path
global external_drive_path
global output_drive_path
SetLocalPaths();
% End machine-specific paths

datename = 'Flat_Field_Calibration_Aug16-2019';
showFig = 0;

% Apply calibration to left orientation
Calibrate_Orientation([google_drive_path filesep '11) Science and Post-Processing'...
    filesep 'Test Data' filesep datename 'Sun Variable Exposure'], 'Left',...
    'LeftCalibration', 0);

% Apply calibration to right orientation
Calibrate_Orientation([google_drive_path filesep '11) Science and Post-Processing'...
    filesep 'Test Data' filesep datename 'Sun Variable Exposure'], 'Right',...
    'RightCalibration', 0);

% Apply cablibration to down orientation
Calibrate_Orientation([google_drive_path filesep '11) Science and Post-Processing'...
    filesep 'Test Data' filesep datename 'Sun Variable Exposure'], 'Down',...
    'DownCalibration', 0);