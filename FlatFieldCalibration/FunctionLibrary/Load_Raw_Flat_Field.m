%{
    This function accepts a file location for raw calibration data and
    returns the raw calibrated into a usable container with nitrogen data.
    The format for the array `nitrogen` is all of the frames in order, with
    the frame count `frames` being set to the offset for each exposure
    time.
    It is left to the calibration function to correctly parse this data. 
%}
function [nitrogen] = Load_Raw_Flat_Field(path,...
    start_frame, end_frame,...
    frame_per_exposure, start_exposure,...
    end_exposure, exposure_count)
%'MethaneTest2_061019_padded'
image_src = path;

frames = end_frame - start_frame + 1;

% Nitrogen
frame_store = imageDatastore(image_src);
nitrogen = zeros(256,320,exposure_count*frames);
% Load in frames by exposure count
index = 0;
for cur_frame = start_frame:end_frame
    for cur_exposure = start_exposure:end_exposure
        index = index + 1;
        % Read col major instead of row major
        frame_loc = (cur_exposure-start_exposure)*frame_per_exposure + cur_frame;
        
        nitrogen(:,:,index) = double(readimage(frame_store, frame_loc));
    end
end