%% Load Saved Parameters
% Sensitivity Map, gain, offset, camera parameters
setGlobalVariables()
%% Load image directory
pathname = '/Users/jason/Desktop/FINIS/Thu_Aug__1_10-40-51_2019';
frames = imageDatastore([pathname filesep 'IR'], 'includeSubfolders', true);
global N;
N = size(frames.Files(),1);  % The number of images in our data set
%%
% figure
% speed = 5;
% for i = 1:speed:N
%     imagesc(readimage(frames, i)), colormap('gray')
%     title(['frame: ', num2str(i)])
%     frame = getframe(gcf);
% end
%% Load scene information (since we didn't code this in we will just hard code the values)
df = 4000;                             % distance to scene in feet
d = df/3.218;                          % distance to scene in meters
pixelLength = 2*d*tand(8.5040/2)/320;  % the length of a pixel in meters (Meters per Pixel)
pixelHeight = 2*d*tand(6.8032/2)/256;  % the height of a pixel in meters  
%% Load Data from IMU
frameRate = 100;
numImages = N;

fileID = fopen([pathname filesep 'imu_data.txt'], 'r');
tline = fgetl(fileID);
i = 0;
while ischar(tline)
    if (size(tline,2) > 25 && strcmp(tline(1:25), 'Binary Async TimeStartup:'))
        i = i+1;
        IMUtime(i) = str2double(tline(26:size(tline, 2)));
    end
    if (size(tline,2) > 17 && strcmp(tline(1:17),'Binary Async YPR:'))
        k = strfind(tline, ' ');
        j = strfind(tline, ')');
        roll(i)  = str2double(tline(k(5)+1:j(1)-1));
    end
    if (strcmp(tline(1:5),'VEL X'))
        vel(i,1) = str2double(tline(6:size(tline, 2)));
        tline = fgetl(fileID);
        vel(i,2) = str2double(tline(6:size(tline, 2)));
        tline = fgetl(fileID);
        vel(i,3) = str2double(tline(6:size(tline, 2)));
    end
    tline = fgetl(fileID);
end

fclose(fileID);

% Convert the IMUs Meters per second data into pixels per frame data
PPFx = (vel(:,1) / (pixelLength*frameRate));
PPFy = ((vel(:,2) / (pixelHeight*frameRate)))*-1; % this is negative due to the way the IMU is positioned in FINIS

% We also have to consider the roll data, which will contribute toward y
% vel
roll = roll - 90;
% dRoll calculated the degrees of change per frame
dRoll = zeros(size(roll, 1),1);
dRoll(1) = 0;
for i = 2:size(roll,2)
    dRoll(i) = roll(i) - roll(i-1);
end 
meters_of_change_due_to_roll = tand(dRoll) * d;
PPFr = meters_of_change_due_to_roll / (pixelLength*frameRate);
iPPFr = interp1(0:0.25:(size(PPFr, 2)/4)-0.25,roll,0:1/frameRate:(size(vel)/4)-0.25, 'pchip');

% Interpolate these values for each frame
iPPF = interp1(0:0.25:(size(PPFx)/4)-0.25,PPFx,0:1/frameRate:(size(vel)/4)-0.25, 'pchip');;

%% Set up Data structures
minPPF = min(iPPF);             % Pixels per frame
numFrames = ceil(320/minPPF(1));  % The maximum number of frames needed to get one complete data set
numCols = 640;                 % The number of columns in each worldView data storage container
numRows = 256;
cubeSize = [numRows, numCols, numFrames];
%%
figure
    [warpedImagesA, endingTform, indexLoc, framesUsedA, finished] = Load_Cube(cubeSize, 1, frames, iPPF, affine2d([1 0 0; 0 1 0; 320 leftVeer 1]));
    showVideo(warpedImagesA, framesUsedA);
if(~finished)
    [warpedImagesB, endingTform, indexLoc, framesUsedB, ~] = Load_Cube(cubeSize, indexLoc, frames, iPPF, endingTform);
    showVideo(warpedImagesB, framesUsedB);
    aLeads = false; % Are the frames in A taken after the frames in B
    bitmap = Compare_Cubes(warpedImagesA, warpedImagesB, framesUsedA, framesUsedB);
    
    for curIndex = indexLoc:numFrames-1:N   
        if (aLeads)
            [warpedImagesA, endingTform, indexLoc, framesUsedA, ~] = Load_Cube(cubeSize, indexLoc, frames, iPPF, endingTform);
            showVideo(warpedImagesA, framesUsedA);
            aLeads = false;
            temp = Compare_Cubes(warpedImagesB, warpedImagesA, framesUsedB, framesUsedA);
        else
            [warpedImagesB, endingTform, indexLoc, framesUsedB, ~] = Load_Cube(cubeSize, indexLoc, frames, iPPF, endingTform);
            showVideo(warpedImagesB, framesUsedB);
            temp = Compare_Cubes(warpedImagesA, warpedImagesB, framesUsedA, framesUsedB);
            aLeads = true;

        end
    end

else
    notEnoughData = 1
end

%%
figure
speed = 5;
for i = 1:speed:size(warpedImagesA, 3)
    imagesc(warpedImagesA(:,:,i,1)), colormap('gray')
    title(['frame: ', num2str(i)])
    frame = getframe(gcf);
end
%%
figure
x = squeeze(warpedImagesA(150,:,:,1));
imagesc(x), colormap('gray');
