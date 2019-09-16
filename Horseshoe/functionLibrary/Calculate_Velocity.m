function [PPFx, PPFy] = Calculate_Velocity(roll,vel,pixelHeight,frameRate,pixelLength,dAGL)
% Calculate_Y_Velocity inputs all the factors that contribute to y
% velocity, and create one velocity.

PPFx = (vel(:,1) / (pixelLength*frameRate));
PPFy = vel(:,3) /(pixelHeight*frameRate);
roll = roll - 90;
meters_of_change_due_to_roll = tand(roll)* dAGL;
pixels_of_change_due_to_roll = meters_of_change_due_to_roll/ pixelHeight;
deltaRoll = zeros(size(roll, 1),1);
deltaRoll(1) = 0;

for i = 2:size(roll)
    deltaRoll(i) = (pixels_of_change_due_to_roll(i) - pixels_of_change_due_to_roll(i-1)) * 4;
end 


deltaRoll = deltaRoll/frameRate;

%PPFx = -1*(PPFx);
PPFy = -1*(deltaRoll - PPFy);
