%% Dr. Swenson's calibration
% play8ing with doing calibration on FINIS.

% Set machine-specific paths
addpath(genpath('..'));
global google_drive_path
global external_drive_path
global output_drive_path
SetLocalPaths();
% End machine-specific paths

%% 
% Read all of the data files into an array called imagea

start_intensity = 3000;
end_intensity   = 33000;
frame_number    = 6;
datename = 'Flat_Field_Calibration_Aug16-2019';

src_path = [google_drive_path filesep '11) Science and Post-Processing'...
    filesep 'Test Data' filesep datename filesep 'Sun Variable Exposure' ...
    filesep 'Left' filesep];

images={};
for i = start_intensity:1000:end_intensity
    images=[images, [src_path num2str(i,'%05.f') '_' num2str(frame_number,'%02.f') '.tiff']]
end
%images={'1000_1.tiff' '2000_6.tiff' '3000_1.tiff' '4000_6.tiff' '5000_6.tiff' '6000_6.tiff' '7000_1.tiff' '8000_1.tiff' '9000_6.tiff' '10000_6.tiff' '11000_6.tiff' '12000_6.tiff' '13000_6.tiff' '14000_6.tiff' '15000_6.tiff' '16000_6.tiff' '17000_6.tiff' '18000_6.tiff' '19000_6.tiff' '20000_6.tiff' '21000_6.tiff' '22000_6.tiff' '23000_6.tiff' '24000_6.tiff' '25000_6.tiff' '26000_6.tiff' '27000_6.tiff' '28000_6.tiff' '29000_6.tiff' '30000_6.tiff' '31000_6.tiff' '32000_6.tiff' '33000_1.tiff'};
intensity=start_intensity:1000:end_intensity;

N = length(images);
imagea = zeros(256,320,N); % the size of each image is 256 x 320

for i = 1:N
    if exist(images{i}, 'file') == 2
        imagea(:,:,i) = double (importdata(images{i})); 
    else
        fprint('Image file not found')
    end
end

%% Plot the calibration images
figure

% Select which of the images to use for calibration purposes in the
% sections below this plotting section. 
NN = 1:6;  % NN = [2 4 5 6 11 15]

prow = 2; % Change these by hand to set the number of items in NN
pcol = 3;

j=1;
for i = NN
      subplot(prow,pcol,j), imshow(imagea(:,:,i), [0 16383]), title(['Frame ' num2str(i)],'FontSize',16);
    j=j+1;
    
end
figure
j=1;
for i = NN
      subplot(prow,pcol,j), histogram(imagea(:,:,i),'BinLimits',[0,2^14]), title(['Frame ' num2str(i)],'FontSize',16);
    j=j+1;
    
end
%% plot an average of the images.... not very useful

% Find statistics on the calibration images

% find the mean of the data set along all the images and the std
image = mean(imagea(:,:,NN),3);
imagestd = std(imagea(:,:,NN),0,3);

imagemin=min(min(image));
imagemax=max(max(image));
imagestdmin = min(min(imagestd));
imagestdmax = max(max(imagestd));

figure
subplot(3,1,[1 2]), imshow(image, [imagemin imagemax]), title('Average of Frames','FontSize',16);
subplot(3,1,3), histogram(image,'BinLimits',[0,2^14]), title('Histogram of Frames','FontSize',16);
xlabel('Pixal Intensity Value','FontSize',14);
ylabel('Number of Pixals','FontSize',14);

%% plot a single pixal calibration 

row = 120
col = 50
C=squeeze(imagea(row,col,NN))';
Cm=Gain(row,col).*intensity(NN)+Offset(row,col);

figure
plot(intensity(NN),C,'*')
hold on
plot(intensity(NN),Cm,'r')
ylabel('Pixal Value','FontSize',14);
xlabel('Intensity','FontSize',14);

%% find the best linear fit to each pixal vs intensity

A = [ intensity(NN)' ones(length(NN),1)];  % this is the A matrix

Gain = zeros(256,320);
Offset = zeros(256,320);


for i=1:256
    for j=1:320 
        B = squeeze(imagea(i,j,NN))'/A';
        Gain(i,j) = B(1);
        Offset(i,j) = B(2);
    end
end

figure
subplot(3,1,[1 2]), imshow(Gain, [min(min(Gain)) max(max(Gain))]), title('Gain','FontSize',16);
subplot(3,1,3), histogram(Gain,'BinLimits',[min(min(Gain)) max(max(Gain))]), title('Histogram of Gain','FontSize',16);
xlabel('Pixal Intensity Value','FontSize',14);
ylabel('Number of Pixals','FontSize',14);

figure
subplot(3,1,[1 2]), imshow(Offset, [min(min(Offset)) max(max(Offset))]), title('Offset','FontSize',16);
subplot(3,1,3), histogram(Offset,'BinLimits',[min(min(Offset)) max(max(Offset))]), title('Histogram of Offset','FontSize',16);
xlabel('Pixal Intensity Value','FontSize',14);
ylabel('Number of Pixals','FontSize',14);


%% plot the chi error for the fits per pixal as an image

chi=zeros(256,320);

for row=1:256
    for col=1:320

    C=squeeze(imagea(row,col,NN))';
    Cm=Gain(row,col).*intensity(NN)+Offset(row,col);
    chi(row,col) = sqrt(sum((C-Cm).^2));

    end
end

%choose the values for plotting the gain and offset map
low = 50 ;
high = 500 ;

figure
subplot(3,1,[1 2]), imshow(chi, [low high]), title('Chi','FontSize',16);
subplot(3,1,3), histogram(chi,'BinLimits',[low high]), title('Histogram of chi','FontSize',16);
xlabel('Chi error of fit','FontSize',14);
ylabel('Number of Pixals','FontSize',14);

%% Dead Pixal Map

dead=zeros(256, 320);
dead(chi > 500) = 1;
% trying to make a color dead pixal map
% [deadX deadY] = find(chi> 500)
% idx = sub2ind(size(chi), deadX, deadY)
% red = ones(256*320,1)
% green = ones(256*320,1)
% blue = ones(256*320,1)
% red(idx) = 1;
% green(idx) = 0;
% blue(idx) = 0;
% map = [ red green blue]
% 
% %map = [ones(256*320,1) ones(256*320,1) ones(256*320,1)];

figure 
imshow(dead);

%% apply a calibration to a test image

NN=1:8;
prow = 2; % Change these by hand to set the number of items in NN
pcol = 4;

%choose the values for plotting the gain and offset map
low = 500 ;
high = 9000 ;

imageI = zeros(256,320,length(NN));

for i=NN
    imageI(:,:,i) = (imagea(:,:,i) - Offset) ./ Gain ;
end

figure
j=1;
for i = NN
      subplot(prow,pcol,j), imshow(imageI(:,:,i), [low high]), title(['Frame ' num2str(i)],'FontSize',16);
    j=j+1;
    
end
figure
j=1;
for i = NN
      subplot(prow,pcol,j), histogram(imageI(:,:,i),'BinLimits',[low,high]), title(['Frame ' num2str(i)],'FontSize',16);
    j=j+1;
    
end
% 
% figure
% subplot(3,1,[1 2]), imshow(imageI, [min(min(imageI)) max(max(imageI))]), title('Offset','FontSize',16);
% subplot(3,1,3), histogram(imageI,'BinLimits',[min(min(imageI)) max(max(imageI))]), title('Histogram of Offset','FontSize',16);
% xlabel('Pixal Intensity Value','FontSize',14);
% ylabel('Number of Pixals','FontSize',14);
