function [numFrames, images] = Load_Raw_Images(filename)

filepath = fullfile([filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive' filesep 'FINIS' filesep '11) Science and Post-Processing' filesep 'Test Data' filesep filename]);
frames = imageDatastore(filepath);
numFrames = size(frames.Files(),1); % Number of images in file

%gain and offset for radiometric calibration
Gain   = load([filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive' filesep 'FINIS' filesep '11) Science and Post-Processing' filesep 'Saved parameters' filesep 'gain.mat']);
Offset = load([filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive' filesep 'FINIS' filesep '11) Science and Post-Processing' filesep 'Saved parameters' filesep 'offset.mat']);
%cameraParams for optical calibration
cameraParams = load([filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive' filesep 'FINIS' filesep '11) Science and Post-Processing' filesep 'Saved parameters' filesep 'cameraParams.mat']);

images = zeros(256,320,numFrames);
for i = 1:N
    images(:,:,i) = double(readimage(frames, i));
    images(:,:,i) = (images(:,:,i) - Offset) ./ Gain;
    images(:,:,i) = double (undistortImage(images(:,:,i), cameraParams));
end