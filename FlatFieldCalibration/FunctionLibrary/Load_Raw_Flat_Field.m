%{
    This function accepts a file location for raw calibration data and
    returns the raw calibrated into a usable container with nitrogen data.
    The format for the array `nitrogen` is all of the frames in order, with
    the frame count `frames` being set to the offset for each exposure
    time.
    It is left to the calibration function to correctly parse this data. 
%}
function [nitrogen] = Load_Raw_Flat_Field(filename, start_frame, end_frame,...
frame_per_exposure, start_exposure, exposure_count)
global google_drive_path;
%'MethaneTest2_061019_padded'
image_src = fullfile([google_drive_path filesep '11) Science and Post-Processing' filesep 'Test Data' filesep filename]);

frames = end_frame - start_frame;

% Nitrogen
frame_store = imageDatastore(image_src);
nitrogen = zeros(256,320,33*frames);
% Load in frames by exposure count
for i = 1:frames
    for j = 1:exposure_count
        nitrogen(:,:,i*frames+j) = double(readimage(frame_store, (j+start_exposure-1)*exposure_count+(i+start_frame-1)));
    end
end