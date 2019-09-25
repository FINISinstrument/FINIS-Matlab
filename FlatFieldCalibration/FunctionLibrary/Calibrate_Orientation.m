function [gain, offset] = Calibrate_Orientation(src_path, dest_path, orientation, out_name, showFig)
%CALIBRATE_ORIENTATION Performs flat-field calibration for single run
%   This function will perform flat-field calibration for a single
%   orientation of the background with no tube. It takes in a data path
    global output_drive_path
    
    %Calculate Flat_Field parameters
    [gain, offset] = Flat_Field_Calibration([src_path filesep orientation], showFig);

    %Calculate Sensitivity Map
    %sensitivityMap = Generate_Sensitivity_Map(filename, gain, offset, showFig);

    save([dest_path filesep orientation '_Radiometric.mat'], 'gain', 'offset');
    %save([dest_path filesep orientation '_sensitivity'], 'sensitivityMap');
end