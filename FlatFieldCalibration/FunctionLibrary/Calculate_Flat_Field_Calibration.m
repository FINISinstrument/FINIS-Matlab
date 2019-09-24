%{
    Calculate the gain and offset for each pixel in the frame at each
    exposure
%}

function [gain, offset] = Calculate_Flat_Field_Calibration(nitrogen,...
    frames_per_exposure, start_exposure, end_exposure, exposure_count)


X = [((1000*start_exposure):1000:(1000*end_exposure))' ones(exposure_count,1)];

% Initialize gain and offset
gain   = zeros(256,320,exposure_count);
offset = zeros(256,320,exposure_count);

% Calculate gain and offset for each pixel
for row = 1:256
    for col = 1:320
        % Calculate gain/offset for each frame index
        for q = 1:exposure_count
            I = squeeze(nitrogen(row,col,((q-1)*frames_per_exposure+1):(q*frames_per_exposure)));
            P = I/X';
            gain  (row,col,q) = P(1);
            offset(row,col,q) = P(2);
        end
    end
end