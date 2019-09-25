%{
    The intended use of this function is to accept the location of raw
    FINIS data for methane calibration, and put it into a usable format for
    that calibration. 

    This function accepts a file location for raw calibration data, a gain 
    file, and an offset file. The function returns two containers
    containing the radiometrically calibrated nitrogen, and methane data.
    The format for the arrays assumes an image for every single exposure 
    rate for the three tube lengths, and is nitrogen(row,col,frame) with 
    the frames starting with the shortest tube, and at the lowest exposure
    level, continuing to the longest tube at the longest exposure time. It
    is left to the script calling this function to parse the data correctly 
%}
function [nitrogen, methane] = Load_Sensitivity_Map_Calibration(filename)
global google_drive_path;
%'MethaneCalibrationData_09.13.2019'
v5 = fullfile([google_drive_path filesep '11) Science and Post-Processing' filesep 'Test Data' filesep filename filesep 'Vacuum' filesep '5cm']);
v10 = fullfile([google_drive_path filesep '11) Science and Post-Processing' filesep 'Test Data' filesep filename filesep 'Vacuum' filesep '10.16cm']);
v25 = fullfile([google_drive_path filesep '11) Science and Post-Processing' filesep 'Test Data' filesep filename filesep 'Vacuum' filesep '25cm']);
m5 = fullfile([google_drive_path filesep '11) Science and Post-Processing' filesep 'Test Data' filesep filename filesep 'Methane' filesep '5cm']);
m10 = fullfile([google_drive_path filesep '11) Science and Post-Processing' filesep 'Test Data' filesep filename filesep 'Methane' filesep '10.16cm']);
m25 = fullfile([google_drive_path filesep '11) Science and Post-Processing' filesep 'Test Data' filesep filename filesep 'Methane' filesep '25cm']);

numFrames = 31;

% Nitrogen
v5frames = imageDatastore(v5); 
v10frames = imageDatastore(v10);
v25frames = imageDatastore(v25);
nitrogen = zeros(256,320,93);
for i = 1:numFrames
    nitrogen(:,:,i)    = double(readimage(v5frames,i));
    nitrogen(:,:,i+31) = double(readimage(v10frames,i));
    nitrogen(:,:,i+62) = double(readimage(v25frames,i));
end


% Methane
m5frames = imageDatastore(m5);
m10frames = imageDatastore(m10);
m25frames = imageDatastore(m25);
methane = zeros(256,320,93);
for i = 1:numFrames
    methane(:,:,i)    = double(readimage(m5frames,i));
    methane(:,:,i+31) = double(readimage(m10frames,i));
    methane(:,:,i+62) = double(readimage(m25frames,i));
end
