function [gain, offset] = Calibrate_Orientation(path, orientation, out_name, showFig)
%CALIBRATE_ORIENTATION Performs flat-field calibration for single run
%   This function will perform flat-field calibration for a single
%   orientation of the background with no tube. It takes in a data path
    global output_drive_path
    
    %Calculate Flat_Field parameters
    [gain, offset] = Flat_Field_Calibration(path, filename, showFig);

    %Calculate Sensitivity Map
    %sensitivityMap = Generate_Sensitivity_Map(filename, gain, offset, showFig);

    % Set save directory to be in ImageCalibration in Google Drive
    save_path = [output_drive_path filesep '11) Science and Post-Processing'...
        filesep 'ImageCalibration' filesep out_name];

    save([save_path filesep orientation '_Radiometric'], 'gain', 'offset');
    %save([save_path filesep orientation '_sensitivity'], 'sensitivityMap');
end