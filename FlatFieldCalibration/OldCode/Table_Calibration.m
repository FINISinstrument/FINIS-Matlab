function calibratedTable = TableCalibration(filename, bool_createFigures)

[nImages, mImages] = Load_Raw_Calibration(filename);

% Calculate the percent change

change = (nImages - mImages)./nImages;
change(isnan(change))=0;

% average values for each tube together

averageChange = zeros(256,320,3);

averageChange(:,:,1) = mean(change(:,:, 1:33),3);
averageChange(:,:,2) = mean(change(:,:,34:66),3);
averageChange(:,:,3) = mean(change(:,:,67:99),3);

clims = [-0.04, 0.3];

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
densityIDX   = [ones(33,1)*10.16; ones(33,1)*25; ones(33,1)*50];
densityIDX   = [densityIDX, ones(99,1)];
coefficients = zeros(256,320,2);
for row = 1:256
    for col = 1:320
        difference = squeeze(change(row,col,:))';
        coefficients(row,col,:) = difference/densityIDX';
    end
end
%%

figure
imagesc(coefficients(:,:,1))
title('Slope')
colorbar

figure
imagesc(coefficients(:,:,2))
title('Y-intercept')
colorbar

%%
