function [time,YPR,vel, LLA] = Load_IMU_Data(pathname)
%Load_IMU_Data This function accepts a filepath, and loads all the data
%recorded by the IMU

fileID = fopen([pathname filesep 'imu_data.txt'], 'r');
tline = fgetl(fileID);
numLines = 0;

% Detirmine the number of lines in the file, there isn't a better way to do
% this, and if we don't do it then we can't know the size of the arrays we
% are dealing with 
while ischar(tline)
    numLines = numLines + 1;
    tline = fgetl(fileID);
end
frewind(fileID)

time = zeros(numLines/8, 1);
YPR = zeros(numLines/8, 3);
vel = zeros(numLines/8, 3);
LLA = zeros(numLines/8, 3);

for i = 1:numLines/8
    % Grab the time stamp
    tline = fgetl(fileID);
    time(i) = str2double(tline(26:size(tline, 2)));

    % Grab YPR data
    tline = fgetl(fileID);
    k = strfind(tline, '; ');
    j = strfind(tline, ')');
    YPR(i,1) = str2double(tline(20:k(1)-1));
    YPR(i,2) = str2double(tline(k(1)+2:k(2)-1));
    YPR(i,3) = str2double(tline(k(2)+2:j-1));
    
    % Grab velocity data
    tline = fgetl(fileID);
    vel(i,1) = str2double(tline(6:size(tline,2)));

    tline = fgetl(fileID);
    vel(i,2) = str2double(tline(6:size(tline,2)));
    
    tline = fgetl(fileID);
    vel(i,3) = str2double(tline(6:size(tline,2)));
    
    % Grab LLA data
    tline = fgetl(fileID);
    LLA(i,1) = str2double(tline(6:size(tline,2)));

    tline = fgetl(fileID);
    LLA(i,2) = str2double(tline(6:size(tline,2)));
    
    tline = fgetl(fileID);
    LLA(i,3) = str2double(tline(6:size(tline,2)));
    
end

fclose(fileID);

end

