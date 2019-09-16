%% User provided information
pathname = '/Volumes/Samsung_T5/Aug 2nd CAL/UTAH/Fri_Aug__2_14-09-43_2019';
name = 'LineAStiched';
global video
global v;
video = 0;
global imageMinInt
global imageMaxInt
%% Load saved Parameters
% Sensitivity Map, gain, offset, camera parameters
setGlobalVariables()
%% Load image directory
frames = imageDatastore([pathname filesep 'IR'], 'includeSubfolders', true);
global N;
N = size(frames.Files(),1);  % The number of images in our data set

[imageMinInt, imageMaxInt] = Calculate_Min_Max_Int(readimage(frames, 1));

%% Load scene information (since we didn't code this in we will just hard code the values)
df = 4000                             % distance to scene in feet
d = df/3.218;                          % distance to scene in meters
pixelLength = 2*d*tand(8.5040/2)/320;  % the length of a pixel in meters (Meters per Pixel)
pixelHeight = 2*d*tand(6.8032/2)/256;  % the height of a pixel in meters  

%% Load Data from IMU
frameRate = 33.33;
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

%% Convert X and Y velocity from m/s to FPS
% note: because of the way the IMU is set up y velocity is measuered in the
%       z direction

PPFx = (vel(:,1) / (pixelLength*frameRate));
PPFy = (vel(:,3) / (pixelHeight*frameRate));

%% Convert Roll data to a Y velocity

roll = roll - 90;
meters_of_change_due_to_roll = tand(roll)* d;
pixels_of_change_due_to_roll = meters_of_change_due_to_roll/ pixelHeight;
deltaRoll = zeros(size(roll, 1),1);
deltaRoll(1) = 0;
for i = 2:size(roll,2)
    deltaRoll(i) = (pixels_of_change_due_to_roll(i) - pixels_of_change_due_to_roll(i-1)) * 4;
end 

deltaRoll = deltaRoll/frameRate;

%% Both PPFy and deltaRoll contribute to Y movement, we can sum them together before interpolation

totalYMovement = -1*(deltaRoll' - PPFy);

%% We now have a pixel per frame estimate at each location, we can interpolate that to all the frames that we have
iPPFx = interp1(0:0.25:(size(PPFx)/4)-0.25,PPFx,0:1/frameRate:(size(vel)/4)-0.25, 'pchip');
iPPFy = interp1(0:0.25:(size(totalYMovement)/4)-0.25,totalYMovement,0:1/frameRate:(size(vel)/4)-0.25, 'pchip');

%% Some sort of method to determine the top and bottom limits
minY = 0;
maxY = 0;
curLoc = 0;
for i = 1:size(iPPFy,2)
    curLoc = curLoc + iPPFy(i);
    if(curLoc > maxY)
        maxY = curLoc;
    end
    if(curLoc < minY)
        minY = curLoc;
    end
end

%% Set up Data structures
minPPF = min(iPPFx);           % Pixels per frame
numFrames = ceil(320/minPPF);  % The maximum number of frames needed to get one complete data set
numCols = 640;                 % The number of columns in each worldView data storage container
numRows = ceil(256 + maxY - minY);
cubeSize = [numRows, numCols, numFrames];
iPPF = [iPPFx; -1*iPPFy];
%% If applicable, set up to record a video

if (video == 1)
    v = VideoWriter(strcat([filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive'  filesep 'FINIS' filesep '11) Science and Post-Processing' filesep 'Videos' filesep 'RawVideo' filesep name '.mp4']), 'MPEG-4');
    v.FrameRate = 30;  % Default 30
    open(v);
end
%%
figure
    [warpedImagesA, endingTform, indexLoc, framesUsedA, finished] = Load_Cube(cubeSize, 1, frames, iPPF, affine2d([1 0 0; 0 1 0; 320 maxY 1]));
    showVideo(warpedImagesA, framesUsedA);
if(~finished)
    [warpedImagesB, endingTform, indexLoc, framesUsedB, ~] = Load_Cube(cubeSize, indexLoc, frames, iPPF, endingTform);
    showVideo(warpedImagesB, framesUsedB);
    
    aLeads = false; % Are the frames in A taken after the frames in B
    %bitmap = Compare_Cubes(warpedImagesA, warpedImagesB, framesUsedA, framesUsedB);
    for curIndex = indexLoc:numFrames-1:N   
        if (aLeads)
            [warpedImagesA, endingTform, indexLoc, framesUsedA, ~] = Load_Cube(cubeSize, indexLoc, frames, iPPF, endingTform);
            showVideo(warpedImagesA, framesUsedA);
            aLeads = false;
            %temp = Compare_Cubes(warpedImagesB, warpedImagesA, framesUsedB, framesUsedA);
        else
            [warpedImagesB, endingTform, indexLoc, framesUsedB, ~] = Load_Cube(cubeSize, indexLoc, frames, iPPF, endingTform);
            showVideo(warpedImagesB, framesUsedB);
            %temp = Compare_Cubes(warpedImagesA, warpedImagesB, framesUsedA, framesUsedB);
            aLeads = true;

        end
    end

else
    notEnoughData = 1
end

%% If applicable, close the video
if (video == 1)
    close(v)
end