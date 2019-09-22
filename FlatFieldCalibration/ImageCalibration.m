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

src_path  = [output_drive_path filesep '11) Science and Post-Processing'...
    filesep, 'Test Data' filesep datename filesep 'Sun Variable Exposure'];
dest_path = [output_drive_path filesep '11) Science and Post-Processing'...
    filesep, 'Test Data' filesep datename filesep 'Calibrated'];

% Get calibration for left orientation
[gain, offset] = Calibrate_Orientation(src_path, 'Left', 'LeftCalibration', 0);
% Apply calibration to left orientation
Apply_FlatField_Folder([src_path filepath 'Left'],[dest_path filesep 'Left'],...
    gain, offset);

% Get calibration for right orientation
[gain, offset] = Calibrate_Orientation(src_path, 'Right', 'RightCalibration', 0);
% Apply calibration to left orientation
Apply_FlatField_Folder([src_path filepath 'Right'],[dest_path filesep 'Right'],...
    gain, offset);

% Get cablibration for down orientation
[gain, offset] = Calibrate_Orientation(src_path, 'Down', 'DownCalibration', 0);
% Apply calibration to left orientation
Apply_FlatField_Folder([src_path filepath 'Down'],[dest_path filesep 'Down'],...
    gain, offset);