function [gain, offset] = Flat_Field_Calibration(filename, boolShowFig)
% Load the data
% filename = 'MethaneTest2_061019_padded';
nitrogen = Load_Raw_Flat_Field(filename);

% Generate Flat Field Calibration Data
[gain, offset] = Calculate_Flat_Field_Calibration(nitrogen);

% Remove "Hot Pixels"
[gain, offset] = Remove_Hot_Pixels(gain, offset);

% Average Flat Field Data together
gain   = mean(gain,3);
offset = mean(offset,3);

%% Display the calculated values
if (boolShowFig == 1)
    figure
    imagesc(gain)
    title('Gain')
    colorbar

    figure
    imagesc(offset)
    title('Offset')
end