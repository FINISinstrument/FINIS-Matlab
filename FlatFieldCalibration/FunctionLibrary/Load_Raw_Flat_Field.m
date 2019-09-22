%{
    This function accepts a file location for raw calibration data and
    returns the raw calibrated into a usable container with nitrogen data.
    The format for the array `nitrogen` is all of the frames in order, with
    the frame count `frames` being set to the offset for each exposure
    time.
    It is left to the calibration function to correctly parse this data. 
%}
function [nitrogen] = Load_Raw_Flat_Field(base_path, filename,...
    start_frame, end_frame,...
    frame_per_exposure, exposure_count)
%'MethaneTest2_061019_padded'
image_src = fullfile([base_path filesep filename]);

frames = end_frame - start_frame;

% Nitrogen
frame_store = imageDatastore(image_src);
nitrogen = zeros(256,320,33*frames);
% Load in frames by exposure count
for i = 1:frames
    for j = 1:exposure_count
        % Indexing for the readimage is wrong
        % Read col major instead of row major
        % row = (j-1)*frame_per_exposure
        % col = i+start_frame-1
        nitrogen(:,:,i*frames+j) = double(readimage(frame_store, ( (j-1)*frame_per_exposure + i+start_frame-1 ) ));
    end
end