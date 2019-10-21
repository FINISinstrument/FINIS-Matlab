% Set machine-specific paths
addpath(genpath('..'));
global google_drive_path
global external_drive_path
global output_drive_path
SetLocalPaths();


basepath = [google_drive_path filesep '11) Science and Post-Processing' filesep...
    'Saved parameters'];
gain = load([basepath filesep 'ff_gain.mat'], 'gain');
gain = gain.gain;
offset = load([basepath filesep 'ff_offset.mat'], 'offset');
offset = offset.offset;
cameraParams = load([basepath filesep 'CameraParams.mat']);


frames = imageDatastore(...
    [external_drive_path '/Aug 2nd CAL/UTAH/Fri_Aug__2_13-59-00_2019']...
    , 'IncludeSubfolder', true);

N = numel(frames.Files);

% read images
images = zeros(256,320,N);
for i = 1:N
    images(:,:,i) = double(readimage(frames, i));
end

% Apply flat field
images = (images-offset)./gain;

% Apply Optical
%{
for i = 1:N
    images(:,:,i) = undistortImage(images(:,:,i), cameraParams);
end
%}
%Flip images
images = fliplr(images);

%% Known Methane
%passBand2 = images(170:210,1:76,707);
%absorption2 = images(183:223,223:298,762);
Generate_Contour(images, 707, 170, 1, 762, 183, 223, 40, 75, 1);

%% Car driving down
passBand2 = images(82:181,14:99,648);
absorption2 = images(101:200,225:310,700);
Generate_Contour(images, 648, 82, 14, 700, 101, 225, 100, 85, 1);