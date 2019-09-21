%% Load the Data
load([filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive' filesep 'FINIS' filesep '11) Science and Post-Processing' filesep 'Saved parameters' filesep 'gain.mat']);
load([filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive' filesep 'FINIS' filesep '11) Science and Post-Processing' filesep 'Saved parameters' filesep 'offset.mat']);
load([filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive' filesep 'FINIS' filesep '11) Science and Post-Processing' filesep 'Saved parameters' filesep 'cameraParams.mat']);


% 10.16cm tube
n10 = fullfile([filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive' filesep 'FINIS' filesep '11) Science and Post-Processing' filesep 'Test Data' filesep 'MethaneTest2_061019_padded' filesep 'Nitrogen' filesep '10.16cm']);
n10frames = imageDatastore(n10);
size10 = size(n10frames.Files(),1); 
images10 = zeros(256,320,size10);
for i = 1:size10
    images10(:,:,i) = double(readimage(n10frames,i));
end

% 25cm tube
n25 = fullfile([filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive' filesep 'FINIS' filesep '11) Science and Post-Processing' filesep 'Test Data' filesep 'MethaneTest2_061019_padded' filesep 'Nitrogen' filesep '25cm']);
n25frames = imageDatastore(n25);
size25 = size(n25frames.Files(),1); 
images25 = zeros(256,320,size25);
for i = 1:size25
    images25(:,:,i) = double(readimage(n25frames,i));
end


% 50cm tube
n50 = fullfile([filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive' filesep 'FINIS' filesep '11) Science and Post-Processing' filesep 'Test Data' filesep 'MethaneTest2_061019_padded' filesep 'Nitrogen' filesep '50cm']);
n50frames = imageDatastore(n50);
size50 = size(n50frames.Files(),1);
images50 = zeros(256,320,size50);
for i = 1:size50
    images50(:,:,i) = double(readimage(n50frames,i));
end
%% Calibrate the images using the previous flat field comparison
video = 1;
if (video == 1)
    name = 'previousFlatField';
    v = VideoWriter(strcat([filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive'  filesep 'FINIS' filesep '11) Science and Post-Processing' filesep 'Videos' filesep name '.mp4']), 'MPEG-4');
    v.FrameRate = 10;  % Default 30
    open(v);
end

exposures = 1000:1000:33000;

images10C = (images10 - Offset) ./Gain;
images25C = (images25 - Offset) ./Gain;
images50C = (images50 - Offset) ./Gain;

minI = min([min(images10C, [], 'all') min(images25C, [], 'all') min(images50C, [], 'all') ]);
maxI = max([max(images10C, [], 'all') max(images25C, [], 'all') max(images50C, [], 'all') ]);
clims = [minI, maxI];

for i = 1:size10 
   
   colormap('gray')
   
   subplot(2,3,1),imagesc(images10C(:,:,i), clims);
   title('10.16cm density')
   colorbar
   subplot(2,3,4),histogram(images10C(:,:,i), 'BinLimits', [minI maxI]);
   
   subplot(2,3,2),imagesc(images25C(:,:,i), clims);
   title('25cm density')
   colorbar
   subplot(2,3,5),histogram(images25C(:,:,i), 'BinLimits', [minI maxI]);
   
   subplot(2,3,3),imagesc(images50C(:,:,i), clims);
   title('50cm density')
   colorbar
   subplot(2,3,6),histogram(images50C(:,:,i), 'BinLimits', [minI maxI]);
   
   sgtitle(['Exposure time: ' num2str(exposures(i))])
   frame = getframe(gcf);
   if (video == 1)
       writeVideo(v,frame)
   end
end

if (video == 1)
    close(v)
end

figure
for i = 1:size10
    histogram(images10C(:,:,i), 'BinLimits', [0 10000]);
    hold on
    histogram(images25C(:,:,i), 'BinLimits', [0 10000]);
    histogram(images50C(:,:,i), 'BinLimits', [0 10000]);
    hold off
    frame = getframe(gcf);
end

%%
% idx=images==0;
% out=sum(idx(:))

images(images == 0 ) = NaN;
imagesMR(imagesMR == 0) = NaN;

imageMin = min(rmoutliers(images(:),'percentiles',[5 100]));
imageMax = max(rmoutliers(images(:),'percentiles',[0 99]));

mrMin = min(rmoutliers(imagesMR(:),'percentiles',[5 100]));
mrMax = max(rmoutliers(imagesMR(:),'percentiles',[0 99]));

% iterate through each image, and it's associated histogram
figure
for i = 1:N
    subplot(2,1,1),imagesc(imagesMR(:,:,i));
    colormap('gray');
    colorbar
    subplot(2,1,2),histogram(imagesMR(:,:,i),'BinLimits',[mrMin mrMax]);
    
    frame = getframe(gcf);
    
    if (video == 1)
        writeVideo(v,frame);
    end
end

if (video == 1)
    close(v)
end


% Overlay all of the histograms on-top of eachother
figure
for i = 1:N
    hold on
    histogram(imagesMR(:,:,i),'BinLimits',[mrMin mrMax])
    hold off
end

%% Create a flat field comparison for a given nitrogen density

% The magic behind the solution
%{
    The method for solving for the gain and the offset of the calibration
    is to make a pixel by pixel comparison of intensity against exposure 
    time, and then fitting the line i = (g*x)+o (Intensity equals
    gain*exposure time + offset) by solving for both gain and offset, we
    can set the intensity equal to the exposure time, by subtracting the
    offset and dividing by the gain (element wise) i =(g*x +o - o)./g=>i=x
    We can solve for both gain and offset in a linear algebra way by
    thinking the intensity I as a column vector containing all the
    intensities for any given exposure time. X as an nx2 matrix containing
    a row of exposure times, and a row of all ones. and P as a 2x1 matrix
    containg the gain and offset for the matrix.
                I = X*P
    To solve for P, the gain and offset, we only need to multiply by the
    inverse of X on both sides. in matlab this looks like:
                P = I/X' 
%}

X = [(1000:1000:33000)' ones(33,1)];

Gain10   = zeros(256,320);
Offset10 = zeros(256,320);

Gain25   = zeros(256,320);
Offset25 = zeros(256,320);

Gain50   = zeros(256,320);
Offset50 = zeros(256,320);

for row = 1:256
    for col = 1:320
        I = squeeze(images10(row,col,:))';
        P = I/X';
        Gain10(row,col)   = P(1);
        Offset10(row,col) = P(2);

        I = squeeze(images25(row,col,:))';
        P = I/X';
        Gain25(row,col)   = P(1);
        Offset25(row,col) = P(2);
        
        I = squeeze(images50(row,col,:))';
        P = I/X';
        Gain50(row,col)   = P(1);
        Offset50(row,col) = P(2);
    end
end

images10CU = (images10 - Offset10) ./Gain10;
images25CU = (images25 - Offset25) ./Gain25;
images50CU = (images50 - Offset50) ./Gain50;

minI = min([min(images10CU, [], 'all') min(images25CU, [], 'all') min(images50CU, [], 'all') ]);
maxI = max([max(images10CU, [], 'all') max(images25CU, [], 'all') max(images50CU, [], 'all') ]);
clims = [minI, maxI];


video = 1;
if (video == 1)
    name = 'Unique Flat Field Comparison';
    v = VideoWriter(strcat([filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive'  filesep 'FINIS' filesep '11) Science and Post-Processing' filesep 'Videos' filesep name '.mp4']), 'MPEG-4');
    v.FrameRate = 10;  % Default 30
    open(v);
end

figure
for i = 1:size10 
   
   colormap('gray')
   
   subplot(2,3,1),imagesc(images10CU(:,:,i), clims);
   title('10.16cm density')
   colorbar
   subplot(2,3,4),histogram(images10CU(:,:,i), 'BinLimits', [minI maxI]);
   
   subplot(2,3,2),imagesc(images25CU(:,:,i), clims);
   title('25cm density')
   colorbar
   subplot(2,3,5),histogram(images25CU(:,:,i), 'BinLimits', [minI maxI]);
   
   subplot(2,3,3),imagesc(images50CU(:,:,i), clims);
   title('50cm density')
   colorbar
   subplot(2,3,6),histogram(images50CU(:,:,i), 'BinLimits', [minI maxI]);
   
   sgtitle(['Unique Calibration Exposure time: ' num2str(exposures(i))])
   frame = getframe(gcf);
   if (video == 1)
        writeVideo(v, frame)
   end
end

figure
for i = 1:size10
    histogram(images10CU(:,:,i));
    hold on
    histogram(images25CU(:,:,i));
    histogram(images50CU(:,:,i));
    legend('10.16cm', '25cm', '50cm')
    hold off
    sgtitle(['Exposure Rate: ', num2str(exposures(i))])
    frame = getframe(gcf);
    if (video ==2)
        writeVideo(v,frame);
    end
end

if (video == 1)
    close(v)
end

%%

video = 1;
if (video == 1)
    name = 'Raw Data';
    v = VideoWriter(strcat([filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive'  filesep 'FINIS' filesep '11) Science and Post-Processing' filesep 'Videos' filesep name '.mp4']), 'MPEG-4');
    v.FrameRate = 10;  % Default 30
    open(v);
end

exposures = 1000:1000:33000;


minI = min([min(images10, [], 'all') min(images25, [], 'all') min(images50, [], 'all') ]);
maxI = max([max(images10, [], 'all') max(images25, [], 'all') max(images50, [], 'all') ]);
minI = 0;
maxI = 5000;
clims = [minI, maxI];

for i = 1:size10 
   
   colormap('gray')
   
   subplot(2,3,1),imagesc(images10(:,:,i), clims);
   title('10.16cm density')
   colorbar
   subplot(2,3,4),histogram(images10(:,:,i), 'BinLimits', [minI maxI]);
   
   subplot(2,3,2),imagesc(images25(:,:,i), clims);
   title('25cm density')
   colorbar
   subplot(2,3,5),histogram(images25(:,:,i), 'BinLimits', [minI maxI]);
   
   subplot(2,3,3),imagesc(images50(:,:,i), clims);
   title('50cm density')
   colorbar
   subplot(2,3,6),histogram(images50(:,:,i), 'BinLimits', [minI maxI]);
   
   sgtitle(['Original Exposure time: ' num2str(exposures(i))])
   frame = getframe(gcf);
   if (video == 1)
       writeVideo(v,frame)
   end
end

if (video == 1)
    close(v)
end






