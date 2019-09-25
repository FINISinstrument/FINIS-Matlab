function [] = Apply_FlatField_Folder(src,dest,gain,offset)
%APPLY_FLATFIELD_FOLDER Apply flat field calibration to folder
%   Read all images located in folder `dest`, and call
%   `Apply_Flat_Field_Calibration` for each image. Write calibrated images
%   to `src`

    % Create datastore
    src_frames = imageDatastore(src);
    N = size(src_frames.Files);
    
    for i = 1:N
        % Read image
        [img, info] = readimage(src_frames,i);
        % Calibrate image
        img = Apply_Flat_Field_Calibration(img, gain, offset);
        % Save image
        info = info.Filename;
        [fpath, fname, ext] = fileparts(info)
        imwrite(img, [dest filesep fname ext]);
    end
end
