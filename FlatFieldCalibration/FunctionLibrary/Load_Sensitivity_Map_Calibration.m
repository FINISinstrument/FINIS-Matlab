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
%'MethaneTest2_061019_padded'
n10 = fullfile([google_drive_path filesep '11) Science and Post-Processing' filesep 'Test Data' filesep filename filesep 'Nitrogen' filesep '10.16cm']);
n25 = fullfile([google_drive_path filesep '11) Science and Post-Processing' filesep 'Test Data' filesep filename filesep 'Nitrogen' filesep '25cm']);
n50 = fullfile([google_drive_path filesep '11) Science and Post-Processing' filesep 'Test Data' filesep filename filesep 'Nitrogen' filesep '50cm']);
m10 = fullfile([filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive' filesep 'FINIS' filesep '11) Science and Post-Processing' filesep 'Test Data' filesep filename filesep 'Methane' filesep '10.16cm']);
m25 = fullfile([filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive' filesep 'FINIS' filesep '11) Science and Post-Processing' filesep 'Test Data' filesep filename filesep 'Methane' filesep '25cm']);
m50 = fullfile([filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive' filesep 'FINIS' filesep '11) Science and Post-Processing' filesep 'Test Data' filesep filename filesep 'Methane' filesep '50cm']);

numFrames = 33;

% Nitrogen
n10frames = imageDatastore(n10); 
n25frames = imageDatastore(n25);
n50frames = imageDatastore(n50);
nitrogen = zeros(256,320,99);
for i = 1:numFrames
    nitrogen(:,:,i)    = double(readimage(n10frames,i));
    nitrogen(:,:,i+33) = double(readimage(n25frames,i));
    nitrogen(:,:,i+66) = double(readimage(n50frames,i));
end


% Methane
m10frames = imageDatastore(m10);
m25frames = imageDatastore(m25);
m50frames = imageDatastore(m50);
methane = zeros(256,320,99);
for i = 1:numFrames
    methane(:,:,i)    = double(readimage(m10frames,i));
    methane(:,:,i+33) = double(readimage(m25frames,i));
    methane(:,:,i+66) = double(readimage(m50frames,i));
end
