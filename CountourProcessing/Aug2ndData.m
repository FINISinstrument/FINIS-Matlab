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
passBand = images(:,:,707);
absorption = images(:,:,762);

%%
figure
subplot(1,2,1),imagesc(passBand), colormap('gray'), title('Pass Band')
subplot(1,2,2),imagesc(absorption), colormap('gray'), title('Absorption Band')

%% manually align images

%% "Known" methane
%passBand2 = images(170:210,1:76,707);
%absorption2 = images(183:223,223:298,762);
passBand2 = images(180:200,11:66,707);
absorption2 = images(193:213,233:288,762);
%% Car driving down
passBand = images(:,:,648);
absorption = images(:,:,710);
%passBand2 = images(170:210,1:76,648);
%absorption2 = images(183:223,223:298,762);
%passBand2 = images(82:181,14:99,648);
%passBand2 = images(:,:,648);
%absorption2 = images(101:200,225:310,700);

%762
%707

figure
subplot(1,2,1),imagesc(passBand2), colormap('gray'), title('Pass Band')
subplot(1,2,2),imagesc(absorption2), colormap('gray'), title('Absorption Band')
%%
%passBand2(25,42) = NaN;
%passBand2(25,42) = mean(passBand2(24:26,41:43), 'all','omitnan');

figure
subplot(1,2,1),imagesc(passBand2), colormap('gray'), title('Pass Band')
subplot(1,2,2),imagesc(absorption2), colormap('gray'), title('Absorption Band')

figure
imshowpair(passBand2, absorption2)

figure
subplot(1,2,1), imagesc(absorption2 - passBand2)
subplot(1,2,2), contour(absorption2/passBand2)

%% Part of manually align images, just the contour
figure
hold on
%imagesc(absorption2)
colormap('gray')
imagesc(absorption2 - passBand2)
contour(absorption2 - passBand2)
title('Subtraction')
colorbar;
saveas(gcf, 'subtraction.jpg');

figure
title('Division')
hold on
imagesc(absorption2)
colormap('gray')
%contour(absorption2 ./ passBand2)
colorbar;
saveas(gcf, 'division.jpg');

figure
imagesc(absorption2)
title('Absorption')
colormap('gray')
colorbar;
saveas(gcf, 'absorption.jpg');

figure
imagesc(passBand2)
title('Passband')
colormap('gray')
colorbar;
saveas(gcf, 'passband.jpg');

%%

[optimizer, metric] = imregconfig('monomodal');
tform = imregtform(passBand2,absorption2,'translation',optimizer,metric);
aligned = imwarp(absorption2, tform);
figure
subplot(1,2,1),imagesc(passBand2), colormap('gray'), title('Pass Band')
subplot(1,2,2),imagesc(aligned), colormap('gray'), title('Absorption Band')


%%
figure
subplot(1,2,1),imagesc(passBand2), colormap('gray'), title('Pass Band')
subplot(1,2,2),imagesc(aligned), colormap('gray'), title('Absorption Band (warped)')

figure
subplot(1,2,1), imagesc(aligned - passBand2),colorbar, title ('Subtracted Images')
subplot(1,2,2), contour(aligned/passBand2), title('Ratio of Absorption band to Pass Band')


%%

[optimizer, metric] = imregconfig('monomodal');
tform = imregtform(passBand2,absorption2,'affine',optimizer,metric);
aligned2 = imwarp(absorption2, tform);
figure
subplot(1,2,1),imagesc(passBand2), colormap('gray'), title('Pass Band')
subplot(1,2,2),imagesc(aligned2), colormap('gray'), title('Absorption Band')

figure
histogram(passBand2)
hold on
histogram(aligned2)
legend('unaltered','warped')

figure
subplot(1,2,1), imagesc(aligned2 - passBand2),colorbar, title ('Subtracted Images')
subplot(1,2,2), contour(aligned2/passBand2), title('Ratio of Absorption band to Pass Band')

