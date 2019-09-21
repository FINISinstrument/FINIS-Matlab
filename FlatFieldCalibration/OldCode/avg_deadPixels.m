function averaged = avg_deadPixels(image)
load([filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive' filesep 'FINIS' filesep '11) Science and Post-Processing' filesep 'Saved parameters' filesep 'DeadPixelMap.mat'], 'bitmap');
averaged = zeros(256,320);
for row = 1:256
    for col = 1:320
        if (bitmap(row,col) == 1)
            averaged(row,col) = (sum(image(row-1:row+1,col-1:col+1), 'all') - image(row,col))/8;
        else
            averaged(row,col) = image(row,col);
        end
    end
end