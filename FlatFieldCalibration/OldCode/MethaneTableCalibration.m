[nImages, mImages] = Load_Radiometric_Calibration('MethaneTest2_061019_padded', GainA, OffsetA);

% Calculate the percent change

change = (nImages - mImages)./nImages;

% While mainting the grouping of tube length, calculate an average change
% for each tube length (collecting data from the different exposure times)
% to create that average

averageChange = zeros(256,320,3);

averageChange(:,:,1) = mean(change(:,:, 1:33),3);
averageChange(:,:,2) = mean(change(:,:,34:66),3);
averageChange(:,:,3) = mean(change(:,:,67:99),3);

%clims = [min(averageChange, [], 'all'), max(averageChange, [], 'all')];
clims = [0 1];

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
%%
% This density index comes from an understanding of how the calibration
% data was collected. Every calibrator took an image at every exposure rate
% recored (1000-33000) at 1000ms increments. As far as the voodoo magic
% going on here, this is just a linear fit line that we are applying to the
% data
densityIDX   = [ones(33,1)*10.16; ones(33,1)*25; ones(33,1)*50];
densityIDX   = [densityIDX, ones(99,1)];
coefficients = zeros(256,320,2);
for row = 1:256
    for col = 1:320
        difference = squeeze(change(row,col,:))';
        coefficients(row,col,:) = difference/densityIDX';
    end
end

save( 'MethaneDifferenceTable', 'coefficients')
%%

% Display the slope and y intercept of the lines that we just calculated. 
minVal = min(coefficients(:,:,1), [], 'all');
maxVal = max(coefficients(:,:,1), [], 'all');

figure
imagesc(coefficients(:,:,1))
title('Slope')
colorbar

figure
imagesc(coefficients(:,:,2), clims)
title('Y-intercept')
colorbar


