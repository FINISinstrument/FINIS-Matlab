function [gain, offset] = Flat_Field_Calibration(base_path, boolShowFig)
% Set variables
start_frame = 5;
end_frame   = 9;
frames_per_exposure = 10;
start_exposure = 3;
end_exposure   = 33;
exposure_count = 31;

% Load the data
% filename = 'MethaneTest2_061019_padded';
fprintf('Load_Raw_Flat_Field')
[nitrogen] = Load_Raw_Flat_Field(base_path, start_frame, end_frame,...
    frames_per_exposure, start_exposure, end_exposure, exposure_count);

fprintf('Generate_Flat_Field_Calibration')
% Generate Flat Field Calibration Data
[gain, offset] = Calculate_Flat_Field_Calibration(nitrogen,(end_frame-start_frame+1),...
    start_exposure, end_exposure, exposure_count);

% Remove "Hot Pixels"
fprintf('Remove Hot Pixels')
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