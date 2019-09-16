function [x,xq] = Sync_Time(IRTimes,IMUTimes)
%Sync_Time This function matches timestamps from the IR camera to the IMU
%   the purpose of this fucntion is to give our main function all the
%   ingredients needed to interpolate the transforms we get from the IMU to
%   each individual IR frame. Hence, we the outputs of this funciton have
%   inherited their names from the inputs of the interp1 function that they
%   correspond to. 
outputArg1 = IRTimes;
outputArg2 = IMUTimes;
end

