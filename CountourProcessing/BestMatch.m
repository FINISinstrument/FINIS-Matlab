function [best_fit, best_row, best_col, out_image] = BestMatch(images,...
                                       image1, image1_x1, image1_y1,...
                                       image2, width, height)
%GENERATE_COUNTOUR Summary of this function goes here
%   Detailed explanation goes here

    % Store best fit
    best_fit = Inf;
    best_row = 0;
    best_col = 0;
    
    % Get base absorption image
    passBand = images(image1_x1:image1_x1+width, image1_y1:image1_y1+height, image1);
    
    % Iterate over all positions
    image = images(:,:,image2);
    for col = 1:size(image,1)-width-1
        for row = 1:size(image,2)-height-1
            % Get offset image
            absorption = image(col:col+width, row:row+height);
            % Calculate diff
            diff = passBand-absorption;
            if (sumsqr(diff) < best_fit)
                best_fit = sumsqr(diff);
                best_row = row;
                best_col = col;
            end
        end
    end
    
    out_image = passBand - image(best_col:best_col+width, best_row:best_row+height);
end
