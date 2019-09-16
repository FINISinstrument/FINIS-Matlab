function [iPPF] = Interpolate_Velocity(xVel,yVel,frameRate)
%Interpolate_Velocity interpolate IMUs 4Hz native frequency to frame rate
%frequency
% vq = interp1(times we sampled at (every .25seconds, velocities at those times, we want to get info about points every 1/frameRate seconds) 
iPPFx = interp1(0:0.25:(size(xVel)/4)-0.25,xVel,0:1/frameRate:(size(xVel)/4)-0.25, 'pchip');
iPPFy = interp1(0:0.25:(size(yVel)/4)-0.25,yVel,0:1/frameRate:(size(yVel)/4)-0.25, 'pchip');
iPPF = [iPPFx; -1*iPPFy];


