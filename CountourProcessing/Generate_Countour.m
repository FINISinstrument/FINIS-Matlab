function [outputArg1,outputArg2] = Generate_Countour(images,...
                                            image1, image1_x1, image1_y1,...
                                            image2, image2_x1, image2_y1,...
                                            width, height)
%GENERATE_COUNTOUR Summary of this function goes here
%   Detailed explanation goes here

% Get sub images
passBand       = images(image1_x1:image1_x1+width , image1_y1:image1_y1+width , image1);
absorptionBand = images(image2_x1:image2_x1+height, image2_y1:image2_y1+hegiht, image2);

figure
subplot(1,2,1),imagesc(passBand), colormap('gray'), title('Pass Band')
subplot(1,2,2),imagesc(absorption), colormap('gray'), title('Absorption Band')
end
