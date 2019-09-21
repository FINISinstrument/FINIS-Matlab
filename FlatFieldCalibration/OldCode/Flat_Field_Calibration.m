function [Offset, Gain] = Flat_Field_Calibration(filename)

%'MethaneTest2_061019_padded'
nitrogen = Load_Raw_Flat_Field(filename);

X = [(1000:1000:33000)' ones(33,1)];

Gain   = zeros(256,320,3);
Offset = zeros(256,320,3);



for row = 1:256
    for col = 1:320
        I = squeeze(nitrogen(row,col,1:33))';
        P = I/X';
        Gain(row,col,1)   = P(1);
        Offset(row,col,1) = P(2);

        I = squeeze(nitrogen(row,col,34:66))';
        P = I/X';
        Gain(row,col,2)   = P(1);
        Offset(row,col,2) = P(2);
        
        I = squeeze(nitrogen(row,col,67:99))';
        P = I/X';
        Gain(row,col,3)   = P(1);
        Offset(row,col,3) = P(2);
    end
end

Offset = mean(Offset,3);
Gain   = mean (Gain, 3);

pixelID = 1:(320*256);

figure
scatter(pixelID, Gain(:));
title('Gain')
xlabel('Pixel')
ylabel('Slope')
fit = polyfit(pixelID,Gain(:)',1); 
hold on
plot(polyval(fit,pixelID))
hold off

figure
scatter(pixelID, Offset(:));
title('Offset')
xlabel('Pixel')
ylabel('y_intercept')
fit = polyfit(pixelID,Offset(:)',1); 
hold on
plot(polyval(fit,pixelID))
hold off












