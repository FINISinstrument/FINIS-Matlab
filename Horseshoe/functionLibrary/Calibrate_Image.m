function calibrated = Calibrate_Image(image)

global gain
global offset
global cameraParams
global imageMinInt
global imageMaxInt

calibrated = double(image);
calibrated = (calibrated-offset)./gain; %Flat field
calibrated = undistortImage(calibrated, cameraParams); % optical 

% Temporary function to average out pixels that are bad, eventually this
% needs to be put into a more robust function of its own
for row = 1:256
    for col = 1:320
        if(isnan(calibrated(row,col)))
            calibrated(row, col) = mean(calibrated(row-1:row+1,col-1:col+1), 'all', 'omitnan');
        end % WARNING this operation may produce an out of bounds error if the bitmap is updated as no checks are made for edge cases
    end
end

calibrated = fliplr(calibrated);

% scale the video pixals from 0 to 1 based on imageMin and imageMax
calibrated = (calibrated - imageMinInt)/(imageMaxInt-imageMinInt);   

