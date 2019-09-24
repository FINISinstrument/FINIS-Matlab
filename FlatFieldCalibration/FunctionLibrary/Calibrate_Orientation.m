function [gain, offset] = Calibrate_Orientation(src_path, dest_path, orientation, out_name, showFig)
%CALIBRATE_ORIENTATION Performs flat-field calibration for single run
%   This function will perform flat-field calibration for a single
%   orientation of the background with no tube. It takes in a data path
    global output_drive_path
    
    %Calculate Flat_Field parameters
    [gain, offset] = Flat_Field_Calibration([src_path filesep orientation], showFig);

    %Calculate Sensitivity Map
    %sensitivityMap = Generate_Sensitivity_Map(filename, gain, offset, showFig);

    % Set save directory to be in ImageCalibration in Google Drive
    %save_path = [output_drive_path filesep '11) Science and Post-Processing'...
    %    filesep 'Test Data' filesep out_name];

    save([dest_path filesep orientation '_Radiometric.mat'], 'gain', 'offset');
    % This is only for Nicholas, not sure why the above line doesn't work
    % with rsync
    %save('/home/chell/work/cse/finis/matlab/Radiometric.mat', 'gain', 'offset');
    %save([save_path filesep orientation '_sensitivity'], 'sensitivityMap');
end