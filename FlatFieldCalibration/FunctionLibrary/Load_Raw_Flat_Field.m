%{
    This function accepts a file location for raw calibration data and
    returns the raw calibrated into a usable container with nitrogen data. 
    The format for the array assumes an image for every single exposure rate
    for the three tube lengths, and is nitrogen(row,col,frame) with the
    frames starting with the shortest tube, and at the lowest exposure
    lever, continuing to the longest tube at the longest exposure time. It
    is left to the calibration function to correctly parse this data. 
%}
function nitrogen = Load_Raw_Flat_Field(filename)
global google_drive_path;
%'MethaneTest2_061019_padded'
n10 = fullfile([google_drive_path filesep '11) Science and Post-Processing' filesep 'Test Data' filesep filename filesep 'Nitrogen' filesep '10.16cm']);
n25 = fullfile([google_drive_path filesep '11) Science and Post-Processing' filesep 'Test Data' filesep filename filesep 'Nitrogen' filesep '25cm']);
n50 = fullfile([google_drive_path filesep '11) Science and Post-Processing' filesep 'Test Data' filesep filename filesep 'Nitrogen' filesep '50cm']);

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