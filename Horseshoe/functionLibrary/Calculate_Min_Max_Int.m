function [imin, imax] = Calculate_Min_Max_Int(image)
% Calculate_Min_Max_Int in order to save time we are going to calculate the 
% minimum and maximum intensities of one image and assume that value is 
% close enough for all frames 
global gain
global offset
global cameraParams

calibrated = double(image);
calibrated = (calibrated-offset)./gain;
calibrated = undistortImage(calibrated, cameraParams);

calibrated(isnan(calibrated)) = 0;

% calculate the min and max to scale image
imin = min(rmoutliers(calibrated(:),'percentiles',[5 100]));
imax = max(rmoutliers(calibrated(:),'percentiles',[0 99]));
end

