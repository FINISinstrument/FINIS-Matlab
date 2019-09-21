function removed = rm_deadPixels(image)
load([filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive' filesep 'FINIS' filesep '11) Science and Post-Processing' filesep 'Saved parameters' filesep 'DeadPixelMap.mat'], 'bitmap');

removed = image.*(imcomplement(bitmap));
removed(removed==0) = NaN;



