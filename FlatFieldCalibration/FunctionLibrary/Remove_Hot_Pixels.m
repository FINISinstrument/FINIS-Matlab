function [gain, offset] = Remove_Hot_Pixels(gain, offset)

% This creates a bitmap that contains the location of the pixels that all
% three calibration tubes agree are bad- bad pixels are defined by pixels 
% whose gain is larger than 0.1 
bitMap = mean(gain <= 0.1, 3);
bitMap(bitMap == 0) = NaN;

% Currently, any "good" gain value at a pixel location will result in the
% pixel not being marked dead. Having a "half-dead" bitmap may need to be
% visited.
bitMap(bitMap ~= 0) = 1;

% Remove the outliers from, gain, and offset data to return 
gain   =   gain.*bitMap;
offset = offset.*bitMap;

