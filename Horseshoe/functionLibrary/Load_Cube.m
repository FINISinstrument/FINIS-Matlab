function [cube, tform, indexLocation, frameNumber, finished] = Load_Cube(cubeSize, indexLocation, frames, velocity, prevTform)

finished = false;
cube = zeros(cubeSize(1),cubeSize(2),cubeSize(3), 3);
tform = affine2d([1 0 0; 0 1 0; 0 0 1]); % we have to declare the variable 'tform' to be an affine2d
tform.T = prevTform.T * affine2d([1 0 0; 0 1 0; 320 0 1]).T; % Roll back the tform to the starting location
tform.T = tform.T * affine2d([1 0 0; 0 1 0; -velocity(1,indexLocation) velocity(2,indexLocation) 1]).T;
curFrame = Calibrate_Image(readimage(frames, indexLocation));

global N
global sensitivityMap
worldView_ref = imref2d([cubeSize(1), cubeSize(2)]);

cube (:,:,1,1) = imwarp(curFrame             , tform, 'outputview', worldView_ref, 'fillValue', NaN);
cube (:,:,1,2) = imwarp(sensitivityMap(:,:,1), tform, 'outputView', worldView_ref, 'fillValue', NaN);
cube (:,:,1,3) = imwarp(sensitivityMap(:,:,2), tform, 'outputView', worldView_ref, 'fillValue', NaN);
frameNumber = 2;
done = false;

indexLocation = indexLocation + 1;
while (~done)
   if (indexLocation > N) % First make sure that we have a frame to grab
       done = true;
       finished = true;
   else
       tform.T = tform.T * affine2d([1 0 0; 0 1 0; -velocity(1,indexLocation) velocity(2,indexLocation) 1]).T;
       if (tform.T(3,1) < 0) % Then make sure that the frame doesnt belong in the next window
           done = true;
       else
         curFrame = Calibrate_Image(readimage(frames, indexLocation));
         cube (:,:,frameNumber,1) = imwarp(curFrame             , tform, 'outputview', worldView_ref, 'fillValue', NaN);
         cube (:,:,frameNumber,2) = imwarp(sensitivityMap(:,:,1), tform, 'outputView', worldView_ref, 'fillValue', NaN);
         cube (:,:,frameNumber,3) = imwarp(sensitivityMap(:,:,2), tform, 'outputView', worldView_ref, 'fillValue', NaN);
         frameNumber = frameNumber + 1;
         indexLocation = indexLocation + 1;
       end
   end
end