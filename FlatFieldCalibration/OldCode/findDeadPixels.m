n10 = fullfile([filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive' filesep 'FINIS' filesep '11) Science and Post-Processing' filesep 'Test Data' filesep 'MethaneTest2_061019_padded' filesep 'Nitrogen' filesep '10.16cm']);
n25 = fullfile([filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive' filesep 'FINIS' filesep '11) Science and Post-Processing' filesep 'Test Data' filesep 'MethaneTest2_061019_padded' filesep 'Nitrogen' filesep '25cm']);
n50 = fullfile([filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive' filesep 'FINIS' filesep '11) Science and Post-Processing' filesep 'Test Data' filesep 'MethaneTest2_061019_padded' filesep 'Nitrogen' filesep '50cm']);

load([filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive' filesep 'FINIS' filesep '11) Science and Post-Processing' filesep 'Saved parameters' filesep 'cameraParams.mat']);
load([filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive' filesep 'FINIS' filesep '11) Science and Post-Processing' filesep 'Saved parameters' filesep 'gain.mat']);
load([filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive' filesep 'FINIS' filesep '11) Science and Post-Processing' filesep 'Saved parameters' filesep 'offset.mat']);

n10frames = imageDatastore(n10);
n25frames = imageDatastore(n25); 
n50frames = imageDatastore(n50); 

outliers = zeros(81920,99);

threshold = [.1, 99.9];

for i = 1:33
    %curImage = double(readimage(n10frames,i));
    %curImage = undistortImage(((double(readimage(n10frames,i))- Offset) ./Gain), cameraParams);
    curImage = (double(readimage(n10frames,i))- Offset)./Gain;
    [a,outliers(:,i)] = rmoutliers(curImage(:), 'percentiles', threshold);
    
    curImage = (double(readimage(n25frames,i))- Offset)./Gain;
    [b,outliers(:,i+33)] = rmoutliers(curImage(:), 'percentiles', threshold);
    
    curImage = (double(readimage(n50frames,i))- Offset)./Gain;
    [c,outliers(:,i+66)] = rmoutliers(curImage(:), 'percentiles', threshold);
end

numOutliers = sum(outliers, 'all')/99;
outliersV = sum(outliers,2)/99;
outliersM = reshape(outliersV, [256,320]);
bit = outliersM > .8;
total = sum(bit, 'all');

figure
imagesc(bit)
title(['Bit Map, Dead Pixels Found: ', num2str(total)])

figure
imagesc(outliersM)
title('probability')
colorbar

%%

imageR = rm_deadPixels((double(readimage(n10frames,i))- Offset)./Gain, bit);
imageA = avg_deadPixels((double(readimage(n10frames,i))- Offset)./Gain, bit);

figure
imagesc(imageR)
title('removed')
colormap('gray')

figure
imagesc(imageA)
title('averaged')
colormap('gray')

figure
imagesc(bit)
title('bit')
colormap('gray')







