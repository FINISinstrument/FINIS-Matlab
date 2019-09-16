% Description
%{ 
% The horse shoe method creates a 4d world view arrays that allow us to
% detect methane in the pixels. Because the FINIS camera works by moving
% across the scene, we need to develop a method to align all the data for
% each ground pixel from each of the individual sensors that collected data
% from that particular sensor. 

% In addition to calculating what the recorded intensity was from a
% particular sensor, we also want to know how sensitive that pixel is to
% methane hence the 4d world view. 

% the structure of the worldView is worldView(r,c,f,d) where:
% r: the row of the world view that the sensor collected data for
% c: the column of the world view that the sensor collected data for
% f: the frame that the data was collected from
% d: the data type that is being stored.

% The first element of d stored is the pixel intensity of a world view
% pixel. So if I wanted to know what the intensity that the camera
% collected at row x, col y, for all frames, we could access that data by
% grabbing intensities = worldview(x,y,:,1)

% The second element of d stored is the slope (gain) of how sensitive the
% sensor used to collect data is. Using the previous example we could
% obtain the gains of the pixel sensitivities for the sensor that recorded
% the intesity at that point we would call gains = worldview(x,y,:,2)

% The thirld element is the offest of the sensitivity.             
% sensitivity = worldview(x,y,:,3)

%}


% User provided information (set these values manually)
%pathname = '/Volumes/Seagate Expansion Drive/Aug 2nd CAL/UTAH/Fri_Aug__2_14-09-43_2019';
pathname = '/mnt/Aug 2nd CAL/UTAH/Fri_Aug__2_14-09-43_2019';
%pathname = 'Fri_Aug__2_14-09-43_2019';
df = 4000; % distance to scene in FEET
frameRate = 33.33;
global video
video = 0;
name = 'LineBStiched'; % if saving as an mp4, name of file to save
global v; %for video (no input required)


% calculate pixel dimensions on the ground in meters
d = df/3.218;                          % distance to scene in meters
pixelLength = 2*d*tand(8.5040/2)/320;  % the length of a pixel in meters (Meters per Pixel)
pixelHeight = 2*d*tand(6.8032/2)/256;

% Sensitivity Map, gain, offset, camera parameters
setGlobalVariables()

% Load image directory
frames = imageDatastore([pathname filesep 'IR'], 'includeSubfolders', true);
global N;
N = size(frames.Files(),1);  % The number of images in our data set

% Get an idea of the min and max intensities for normalization (see calibrate Images) 
global imageMinInt
global imageMaxInt
[imageMinInt, imageMaxInt] = Calculate_Min_Max_Int(readimage(frames, 1));

% Load Data from IMU
[IMUtime, YPR, vel, LLA] = Load_IMU_Data(pathname);

% Convert IMU data to Pixel Per Frame velocity
[PPFx, PPFy] = Calculate_Velocity(YPR(:,3),vel,pixelHeight,frameRate,pixelLength,d);

% Interpolate the data from 4Hz(What the IMU records) to frameRate frequency
iPPF = Interpolate_Velocity(PPFx,PPFy,frameRate);

% Measure the left and right veer
[minY, maxY] = Detirmine_Y_Limits(iPPF(2,:));

% Set up Data structures
minPPF = min(iPPF, [], 2);           % Pixels per frame
minPPFx = minPPF(1);
numFrames = ceil(320/minPPFx);  % The maximum number of frames needed to get one complete data set
numCols = 640;                 % The number of columns in each worldView data storage container
numRows = ceil(256 + maxY - minY);
cubeSize = [numRows, numCols, numFrames];

% If applicable, set up to record a video
if (video == 1)
    %v = VideoWriter(strcat([filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive'  filesep 'FINIS' filesep '11) Science and Post-Processing' filesep 'Videos' filesep 'RawVideo' filesep name '.mp4']), 'MPEG-4');
    %v = VideoWriter(strcat(['Videos' filesep name '.mp4']), 'MPEG-4');
    v.FrameRate = 30;  % Default 30
    open(v);
end

% Start stiching frames together!
figure
    [warpedImagesA, endingTform, indexLoc, framesUsedA, finished] = Load_Cube(cubeSize, 1, frames, iPPF, affine2d([1 0 0; 0 1 0; 0 maxY 1]));
    showVideo(warpedImagesA, framesUsedA);
if(~finished)
    [warpedImagesB, endingTform, indexLoc, framesUsedB, ~] = Load_Cube(cubeSize, indexLoc, frames, iPPF, endingTform);
    showVideo(warpedImagesB, framesUsedB);
    
    aLeads = false; % Are the frames in A taken after the frames in B
    %Compare_Cubes(warpedImagesA, warpedImagesB, framesUsedA, framesUsedB);
    for curIndex = indexLoc:numFrames-1:N
        if (aLeads)
            [warpedImagesA, endingTform, indexLoc, framesUsedA, ~] = Load_Cube(cubeSize, indexLoc, frames, iPPF, endingTform);
            showVideo(warpedImagesA, framesUsedA);
            aLeads = false;
            %Compare_Cubes(warpedImagesB, warpedImagesA, framesUsedB, framesUsedA);
        else
            [warpedImagesB, endingTform, indexLoc, framesUsedB, ~] = Load_Cube(cubeSize, indexLoc, frames, iPPF, endingTform);
            showVideo(warpedImagesB, framesUsedB);
            %Compare_Cubes(warpedImagesA, warpedImagesB, framesUsedA, framesUsedB);
            aLeads = true;
        end
    end

else
    notEnoughData = 1
end

% If applicable, close the video
if (video == 1)
    close(v)
end