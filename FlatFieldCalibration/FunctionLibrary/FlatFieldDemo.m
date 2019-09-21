%% NOTE: This script is primarily to demonstrate the validatity of the methods used
filename = 'MethaneTest2_061019_padded';
nitrogen = Load_Raw_Flat_Field(filename);

X = [(1000:1000:33000)' ones(33,1)];

Gain   = zeros(256,320,3);
Offset = zeros(256,320,3);

for row = 1:256
    for col = 1:320
        I = squeeze(nitrogen(row,col,1:33))';
        P = I/X';
        Gain  (row,col,1) = P(1);
        Offset(row,col,1) = P(2);

        I = squeeze(nitrogen(row,col,34:66))';
        P = I/X';
        Gain  (row,col,2) = P(1);
        Offset(row,col,2) = P(2);
        
        I = squeeze(nitrogen(row,col,67:99))';
        P = I/X';
        Gain  (row,col,3) = P(1);
        Offset(row,col,3) = P(2);
    end
end

%% remove all the values greater than 0.1 slope (gain)
bitMap = mean(Gain <= 0.1, 3);
bitMap(bitMap == 0) = NaN;   % We only set NaN to values that all three data sets agreed was greater than 0.1
bitMap(bitMap == (1/3)) = 1;
bitMap(bitMap == (2/3)) = 1;

GainOR     = Gain.*bitMap;        % Remove the outliers from, gain, offset, and nitrogen, so we can see the 
OffsetOR   = Offset.*bitMap;      % nitrogen data normalized as well
nitrogenOR = nitrogen.*bitMap;

%% normalize the data, and calculate the chi data
N1 = zeros(256,320,99); % Normalized orignial Flat-Field data
N2 = zeros(256,320,99); % Normalized flat-field data, with outliers removed

% scale the intensities between 0 and 1 for N1 data
for i = 1:99
    curN = nitrogen(:,:,i);
    curMin = min(curN,[], 'all');
    curMax = max(curN,[],'all');
    N2(:,:,i) = (curN-curMin)/(curMax-curMin);
end

% scale the intensities between 0 and 1 for N2 data
for i = 1:99
    curN = nitrogenOR(:,:,i);
    curMin = min(curN,[], 'all');
    curMax = max(curN,[],'all');
    N1(:,:,i) = (curN-curMin)/(curMax-curMin);
end

GainN   = zeros(256,320,3);  %Gain Normalized
OffsetN = zeros(256,320,3);
for row = 1:256
    for col = 1:320
        I = squeeze(N1(row,col,1:33))';
        P = I/X';
        GainN  (row,col,1) = P(1);
        OffsetN(row,col,1) = P(2);

        I = squeeze(N1(row,col,34:66))';
        P = I/X';
        GainN  (row,col,2) = P(1);
        OffsetN(row,col,2) = P(2);
        
        I = squeeze(N1(row,col,67:99))';
        P = I/X';
        GainN  (row,col,3) = P(1);
        OffsetN(row,col,3) = P(2);
    end
end

GainNOR   = zeros(256,320,3); % Gain normalized outliers removed
OffsetNOR = zeros(256,320,3);
for row = 1:256
    for col = 1:320
        I = squeeze(N2(row,col,1:33))';
        P = I/X';
        GainNOR  (row,col,1) = P(1);
        OffsetNOR(row,col,1) = P(2);

        I = squeeze(N2(row,col,34:66))';
        P = I/X';
        GainNOR  (row,col,2) = P(1);
        OffsetNOR(row,col,2) = P(2);
        
        I = squeeze(N2(row,col,67:99))';
        P = I/X';
        GainNOR  (row,col,3) = P(1);
        OffsetNOR(row,col,3) = P(2);
    end
end

%% Calculate CHI data


chi1 = zeros(256,320,3); % Original data
for row = 1:256
    for col = 1:320
        c = squeeze(nitrogen(row,col,1:33));
        cm = Gain(row,col).*X(:,1) + Offset(row,col);
        chi1(row,col,1) = sqrt(sum((cm-c).^2))/33;
    
        c = squeeze(nitrogen(row,col,34:66));
        cm = Gain(row,col).*X(:,1) + Offset(row,col);
        chi1(row,col,2) = sqrt(sum((cm-c).^2))/33;
        
        c = squeeze(nitrogen(row,col,67:99));
        cm = Gain(row,col).*X(:,1) + Offset(row,col);
        chi1(row,col,3) = sqrt(sum((cm-c).^2))/33;
    end
end

chi2 = zeros(256,320,3); %Normalized Data
for row = 1:256
    for col = 1:320
        c = squeeze(N1(row,col,1:33));
        cm = GainN(row,col).*X(:,1) + OffsetN(row,col);
        chi2(row,col,1) = sqrt(sum((cm-c).^2))/33;
    
        c = squeeze(N1(row,col,34:66));
        cm = GainN(row,col).*X(:,1) + OffsetN(row,col);
        chi2(row,col,2) = sqrt(sum((cm-c).^2))/33;
        
        c = squeeze(N1(row,col,67:99));
        cm = GainN(row,col).*X(:,1) + OffsetN(row,col);
        chi2(row,col,3) = sqrt(sum((cm-c).^2))/33;
    end
end

chi3 = zeros(256,320,3); %Outliers Removed Data
for row = 1:256
    for col = 1:320
        c = squeeze(nitrogenOR(row,col,1:33));
        cm = GainOR(row,col).*X(:,1) + OffsetOR(row,col);
        chi3(row,col,1) = sqrt(sum((cm-c).^2))/33;
    
        c = squeeze(nitrogenOR(row,col,34:66));
        cm = GainOR(row,col).*X(:,1) + OffsetOR(row,col);
        chi3(row,col,2) = sqrt(sum((cm-c).^2))/33;
        
        c = squeeze(nitrogenOR(row,col,67:99));
        cm = GainOR(row,col).*X(:,1) + OffsetOR(row,col);
        chi3(row,col,3) = sqrt(sum((cm-c).^2))/33;
    end
end

chi4 = zeros(256,320,3); %Normalized Outliers Removed Data
for row = 1:256
    for col = 1:320
        c = squeeze(N2(row,col,1:33));
        cm = GainNOR(row,col).*X(:,1) + OffsetNOR(row,col);
        chi4(row,col,1) = sqrt(sum((cm-c).^2))/33;
    
        c = squeeze(N2(row,col,34:66));
        cm = GainNOR(row,col).*X(:,1) + OffsetNOR(row,col);
        chi4(row,col,2) = sqrt(sum((cm-c).^2))/33;
        
        c = squeeze(N2(row,col,67:99));
        cm = GainNOR(row,col).*X(:,1) + OffsetNOR(row,col);
        chi4(row,col,3) = sqrt(sum((cm-c).^2))/33;
    end
end

% calculate average Gain and Offset values to use in calibration
GainA = mean(GainOR, 3);
OffsetA = mean(OffsetOR,3);
save('radiometricCal', 'GainA', 'OffsetA', 'bitMap');


%% Plot the data

pixelID = 1:(320*256);
vectorGain = Gain(:);
vectorOffset = Offset(:);

% Plot the gain and offset 
figure
hold on
scatter(pixelID, vectorGain(1:(320*256)));
scatter(pixelID, vectorGain((320*256)+1:(320*256*2)));
scatter(pixelID, vectorGain((320*256*2)+1:(320*256*3)));

xlabel('Pixel')
ylabel('Gain')

legend('10.16cm', '25cm' , '50cm')
title('Flat Field Calibration Results-Gain')

figure
hold on
scatter(pixelID, vectorOffset(1:(320*256)));
scatter(pixelID, vectorOffset((320*256)+1:(320*256*2)));
scatter(pixelID, vectorOffset((320*256*2)+1:(320*256*3)));

xlabel('Pixel')
ylabel('Offset')

legend('10.16cm', '25cm' , '50cm')
title('Flat Field Calibration Results-Offset')

% plot the gain and offset without outliers
vectorGain = GainOR(:);
vectorOffset = OffsetOR(:);

% Plot the gain and offset 
figure
hold on
scatter(pixelID, vectorGain(1:(320*256)));
scatter(pixelID, vectorGain((320*256)+1:(320*256*2)));
scatter(pixelID, vectorGain((320*256*2)+1:(320*256*3)));

xlabel('Pixel')
ylabel('Gain')

legend('10.16cm', '25cm' , '50cm')
title('Outliers Removed Flat Field Calibration Results-Gain')

figure
hold on
scatter(pixelID, vectorOffset(1:(320*256)));
scatter(pixelID, vectorOffset((320*256)+1:(320*256*2)));
scatter(pixelID, vectorOffset((320*256*2)+1:(320*256*3)));

xlabel('Pixel')
ylabel('Offset')

legend('10.16cm', '25cm' , '50cm')
title('Outliers Removed Flat Field Calibration Results-Offset')
%% Create a Histogram of the CHI data
figure
sgtitle('Histogram of Orignial chi data')
subplot(2,4,1)
imagesc(chi1(:,:,1))
colorbar
title('10.16cm')
subplot(2,4,5)
histogram(chi1(:,:,1));
subplot(2,4,2)
imagesc(chi1(:,:,2))
colorbar
title('25cm')
subplot(2,3,5)
histogram(chi1(:,:,2));
subplot(2,3,3)
imagesc(chi1(:,:,3))
colorbar
title('50cm')
subplot(2,3,6)
histogram(chi1(:,:,3));

figure
sgtitle('Histogram of Normalized chi data')
subplot(2,3,1)
imagesc(chi2(:,:,1))
colorbar
title('10.16cm')
subplot(2,3,4)
histogram(chi2(:,:,1));
subplot(2,3,2)
imagesc(chi2(:,:,2))
colorbar
title('25cm')
subplot(2,3,5)
histogram(chi2(:,:,2));
subplot(2,3,3)
imagesc(chi2(:,:,3))
colorbar
title('50cm')
subplot(2,3,6)
histogram(chi2(:,:,3));

figure
sgtitle('Histogram of chi data with outliers removed')
subplot(2,3,1)
imagesc(chi3(:,:,1))
colorbar
title('10.16cm')
subplot(2,3,4)
histogram(chi3(:,:,1));
subplot(2,3,2)
imagesc(chi3(:,:,2))
colorbar
title('25cm')
subplot(2,3,5)
histogram(chi3(:,:,2));
subplot(2,3,3)
imagesc(chi3(:,:,3))
colorbar
title('50cm')
subplot(2,3,6)
histogram(chi3(:,:,3));

figure
sgtitle('Histogram of chi data with outliers removed and Normalized')
subplot(2,3,1)
imagesc(chi4(:,:,1))
colorbar
title('10.16cm')
subplot(2,3,4)
histogram(chi4(:,:,1));
subplot(2,3,2)
imagesc(chi4(:,:,2))
colorbar
title('25cm')
subplot(2,3,5)
histogram(chi4(:,:,2));
subplot(2,3,3)
imagesc(chi4(:,:,3))
colorbar
title('50cm')
subplot(2,3,6)
histogram(chi4(:,:,3));

%% Display the bitmap

figure
sgtitle('10.16cm Frame')
subplot(1,3,1)
imagesc(nitrogen(:,:,31))
title('Original Image')
colormap('gray')
subplot(1,3,2) 
imagesc(bitMap)
title('Bit Map of bad pixels')
subplot(1,3,3)
imagesc(nitrogenOR(:,:,31))
title('Image with bad pixels removed')

figure
sgtitle('25cm Frame')
subplot(1,3,1)
imagesc(nitrogen(:,:,63))
title('Original Image')
colormap('gray')
subplot(1,3,2) 
imagesc(bitMap)
title('Bit Map of bad pixels')
subplot(1,3,3)
imagesc(nitrogenOR(:,:,63))
title('Image with bad pixels removed')

figure
sgtitle('50cm Frame')
subplot(1,3,1)
imagesc(nitrogen(:,:,90))
title('Original Image')
colormap('gray')
subplot(1,3,2) 
imagesc(bitMap)
title('Bit Map of bad pixels')
subplot(1,3,3)
imagesc(nitrogenOR(:,:,90))
title('Image with bad pixels removed')




