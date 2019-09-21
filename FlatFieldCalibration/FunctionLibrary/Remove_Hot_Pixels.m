function [gain, offset] = Remove_Hot_Pixels(gain, offset)

% This creates a bitmap that contains the location of the pixels that all
% three calibration tubes agree are bad- bad pixels are defined by pixels 
% whose gain is larger than 0.1 
bitMap = mean(gain <= 0.1, 3); 
bitMap(bitMap == 0) = NaN;   
bitMap(bitMap == (1/3)) = 1;
bitMap(bitMap == (2/3)) = 1;

% Remove the outliers from, gain, and offset data to return 
gain     = gain.*bitMap;        
offset   = offset.*bitMap;      

