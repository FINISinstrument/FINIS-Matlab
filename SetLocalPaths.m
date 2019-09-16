function [] = SetLocalPaths()
%SETLOCALPATHS Set paths for local working directory
%   When different machines are used for FINIS post processing,
%   it becomes difficult to manage file paths between the different
%   systems.
%
%   This function should be called at the beginning of any post processing
%   to set local paths to the root folder of input data locations, output
%   data locations, and any other directories that may be mounted at a
%   different location.
%
%   Changes made to this file will not be committed to Github, allowing the
%   user to set and forget the paths. Example paths are included in this
%   function. If additional root paths are needed, submit a pull request
%   with the updated directories. None of these directories should be
%   located in this Git repo.
global google_drive_path;
global external_drive_path;
global output_drive_path;

% Path to locally mounted Google Drive
google_drive_path = [filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive' filesep...
    'FINIS'];

% Path to locally mounted external drive (typically Seagate)
external_drive_path = [filesep 'Volumes' filesep 'Seagate Expansion Drive'];

% Path to where output data is stored
output_drive_path = [filesep 'Volumes' filesep 'GoogleDrive' filesep 'My Drive' filesep...
    'FINIS'];

end