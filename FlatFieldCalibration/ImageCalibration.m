%% Function to do flat field calibration of FINIS instrument

% Set machine-specific paths
addpath(genpath('..'));
global google_drive_path
%global external_drive_path
global output_drive_path
SetLocalPaths();
% End machine-specific paths

filename = 'MethaneCalibrationData_09.13.2019';
datename = 'Flat_Field_Calibration_Aug16-2019';
showFig = 0;

src_path  = [google_drive_path filesep '11) Science and Post-Processing'...
    filesep, 'Test Data' filesep datename filesep 'Sun Variable Exposure'];
dest_path = [output_drive_path filesep '11) Science and Post-Processing'...
    filesep, 'Test Data' filesep datename filesep 'Calibrated'];

% Get calibration for left orientation
[gain, offset] = Calibrate_Orientation(src_path, dest_path, 'Left', 'LeftCalibration', 0);
% Apply calibration to left orientation
Apply_FlatField_Folder([src_path filesep 'Left'],[dest_path filesep 'Left'],...
    gain, offset);

% Get calibration for right orientation
[gain, offset] = Calibrate_Orientation(src_path, dest_path, 'Right', 'RightCalibration', 0);
% Apply calibration to left orientation
Apply_FlatField_Folder([src_path filesep 'Right'],[dest_path filesep 'Right'],...
    gain, offset);

% Get calibration for down orientation
[gain, offset] = Calibrate_Orientation(src_path, dest_path, 'Down', 'DownCalibration', 0);
% Apply calibration to left orientation
Apply_FlatField_Folder([src_path filesep 'Down'],[dest_path filesep 'Down'],...
    gain, offset);