%% Description
%{ 
    This purpose of this script is to generate a pixel by pixel table that
    represents the percent difference of light intensity between nitrogen
    and methane gas. The percent difference is calculated as:
                %Dif = (N2-CH4)/N2
    This will be done for each column density of methane/nitrogen, and then
    a linear fit line will be added
%}
%% Script Directory
%{
    (1) Load the data
%}
%% (1) Load the data

% Image File Locations
filename = 'MethaneTest2_061019_padded';
n10 = fullfile([filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive' filesep 'FINIS' filesep '11) Science and Post-Processing' filesep 'Test Data' filesep filename filesep 'Nitrogen' filesep '10.16cm']);
n25 = fullfile([filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive' filesep 'FINIS' filesep '11) Science and Post-Processing' filesep 'Test Data' filesep 'MethaneTest2_061019_padded' filesep 'Nitrogen' filesep '25cm']);
n50 = fullfile([filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive' filesep 'FINIS' filesep '11) Science and Post-Processing' filesep 'Test Data' filesep 'MethaneTest2_061019_padded' filesep 'Nitrogen' filesep '50cm']);
m10 = fullfile([filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive' filesep 'FINIS' filesep '11) Science and Post-Processing' filesep 'Test Data' filesep 'MethaneTest2_061019_padded' filesep 'Methane' filesep '10.16cm']);
m25 = fullfile([filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive' filesep 'FINIS' filesep '11) Science and Post-Processing' filesep 'Test Data' filesep 'MethaneTest2_061019_padded' filesep 'Methane' filesep '25cm']);
m50 = fullfile([filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive' filesep 'FINIS' filesep '11) Science and Post-Processing' filesep 'Test Data' filesep 'MethaneTest2_061019_padded' filesep 'Methane' filesep '50cm']);

% Saved Parameter Locations
load([filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive' filesep 'FINIS' filesep '11) Science and Post-Processing' filesep 'Saved parameters' filesep 'gain.mat']);
load([filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive' filesep 'FINIS' filesep '11) Science and Post-Processing' filesep 'Saved parameters' filesep 'offset.mat']);

numFrames = 33;                     % I think taking the time to not assume this is true is not
exposureRates = 1000:1000:33000;    % worth the work for calibration we have control over
%% Stuff the images into individual storage containers

% Create a unique container for all of the frames

                                     
% Nitrogen 10.16cm
n10frames = imageDatastore(n10); 
nImages10 = zeros(256,320,numFrames);
for i = 1:numFrames
    nImages10(:,:,i) = undistortImage(((double(readimage(n10frames,i))- Offset) ./Gain), cameraParams);
end

% Nitrogen 25cm
n25frames = imageDatastore(n25);
nImages25 = zeros(256,320,numFrames);
for i = 1:numFrames
    % First the image is flat fielded, then optically corrected
    nImages25(:,:,i) = undistortImage(((double(readimage(n25frames,i))- Offset) ./Gain), cameraParams);
end

% Nitrogen 50cm
n50frames = imageDatastore(n50);
nImages50 = zeros(256,320,numFrames);
for i = 1:numFrames
    nImages50(:,:,i) = undistortImage(((double(readimage(n50frames,i))- Offset) ./Gain), cameraParams);
end

% Methane 10.16cm
m10frames = imageDatastore(m10);
mImages10 = zeros(256,320,numFrames);
for i = 1:numFrames
    mImages10(:,:,i) = undistortImage(((double(readimage(m10frames,i))- Offset) ./Gain), cameraParams);
end

% Methane 25cm
m25frames = imageDatastore(m25);
mImages25 = zeros(256,320,numFrames);
for i = 1:numFrames
    mImages25(:,:,i) = undistortImage(((double(readimage(m25frames,i))- Offset) ./Gain), cameraParams);
end

% Methane 50cm
m50frames = imageDatastore(m50);
mImages50 = zeros(256,320,numFrames);
for i = 1:numFrames
    mImages50(:,:,i) = undistortImage(((double(readimage(m50frames,i))- Offset) ./Gain), cameraParams);
end

%% Do the same thing, only this time create only two objects, not six

% Nitrogen
n10frames = imageDatastore(n10); 
n25frames = imageDatastore(n25);
n50frames = imageDatastore(n50);
nImages = zeros(256,320,99);
for i = 1:numFrames
    nImages(:,:,i)    = undistortImage(((double(readimage(n10frames,i))- Offset) ./Gain), cameraParams);
    nImages(:,:,i+33) = undistortImage(((double(readimage(n25frames,i))- Offset) ./Gain), cameraParams);
    nImages(:,:,i+66) = undistortImage(((double(readimage(n50frames,i))- Offset) ./Gain), cameraParams);
end


% Methane
m10frames = imageDatastore(m10);
m25frames = imageDatastore(m25);
m50frames = imageDatastore(m50);
mImages = zeros(256,320,99);
for i = 1:numFrames
    mImages(:,:,i)    = undistortImage(((double(readimage(m10frames,i))- Offset) ./Gain), cameraParams);
    mImages(:,:,i+33) = undistortImage(((double(readimage(m25frames,i))- Offset) ./Gain), cameraParams);
    mImages(:,:,i+66) = undistortImage(((double(readimage(m50frames,i))- Offset) ./Gain), cameraParams);
end

%% Calculate the percent change

change = (nImages - mImages)./nImages;

% average values for each tube together

averageChange = zeros(256,320,3);

averageChange(:,:,1) = mean(change(:,:, 1:33),3);
averageChange(:,:,2) = mean(change(:,:,34:66),3);
averageChange(:,:,3) = mean(change(:,:,67:99),3);

%%
clims = [-0.04, 0.3];

figure
sgtitle('Average %Difference between methane and nitrogen')
subplot(1,3,1),imagesc(averageChange(:,:,1), clims)
colorbar
title('Density: 10.16cm')

subplot(1,3,2),imagesc(averageChange(:,:,2), clims)
colorbar
title('Density: 25cm')

subplot(1,3,3),imagesc(averageChange(:,:,3), clims)
colorbar
title('Density: 50cm')
