function [] = Generate_Contour(images,...
                               image1, image1_x1, image1_y1,...
                               image2, image2_x1, image2_y1,...
                               width, height, search)
%GENERATE_COUNTOUR Summary of this function goes here
%   Detailed explanation goes here

% Get sub images
passBand   = images(image1_x1:image1_x1+width, image1_y1:image1_y1+height, image1);
absorption = images(image2_x1:image2_x1+width, image2_y1:image2_y1+height, image2);

% Display the set of images
figure
subplot(1,2,1),imagesc(passBand),            colormap('gray'), title('Pass Band'), colorbar
subplot(1,2,2),imagesc(absorption),          colormap('gray'), title('Absorption Band'), colorbar
figure
subplot(1,2,1),imagesc(passBand-absorption), colormap('default'), title('Subtraction'), colorbar
subplot(1,2,2),contour(passBand/absorption), colormap('default'), title('Contour'), colorbar

% Display the contour map
figure
contour(absorption/passBand), colorbar

% If search is enabled, create figure with comparison when image2 is
% shifted by 1 pixel in all 8 directions (up, down, left, right, and
% diagonal)
if (search)
    figure
    % Base comparison
    subplot(3,3,5),imagesc(passBand-absorption,[-750,1700]), colormap('default'), title('Subtraction'), colorbar
    
    % Get base absorption image
    absorption = images(image2_x1:image2_x1+width, image2_y1:image2_y1+height, image2);
    for row = -1:1
        for col = -1:1
            % Get offset of image
            [passBand, valid] = Create_Offset(images(:,:,image1),...
                                              image1_x1,image1_y1,...
                                              width, height,...
                                              row, col);
            if (valid && ~(row==0 && col==0) )
                % Get matrix for analysis
                diff = passBand-absorption;
                index = (row+1)*3 + col+2;
                
                subplot(3,3, index )
                imagesc(diff,[-750,1700])
                colormap('default')
                %title( sumsqr(diff) );
                title( [num2str(index) ': ' num2str(sumsqr(diff),'%5f')] );
                %text(0.5,0.5,'test text');
                colorbar
            end
        end
    end
end

end

function [outImage, valid] = Create_Offset(image, x1, y1, width, height, x_off, y_off)
    outImage = zeros(height,width);
    
    valid = 1;
    % Check if can search left
    if (x1+x_off < 1)
        valid = 0;
    end
    % Check if can search right
    if (x1+x_off > size(image,1))
        valid = 0;
    end
    % Check if can search up
    if (y1+y_off < 1)
        valid = 0;
    end
    % Check if can search down
    if (y1+y_off > size(image,2))
        valid = 0;
    end
    
    if (valid)
        outImage = image(x1+x_off:x1+x_off+width, y1+y_off:y1+y_off+height);
    end
end