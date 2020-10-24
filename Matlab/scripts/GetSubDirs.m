 function [subDirsNames] = GetSubDirs(parentDir)
     % Get a list of all files and folders in this folder.
    files    = dir(parentDir);
    % Get a logical vector that tells which is a directory.
    % Extract only those that are directories.
    dirFlags = [files.isdir] & ~strcmp({files.name},'.') & ~strcmp({files.name},'..');
    
    subDirsNames = files(dirFlags);
    
    
    
    
    
    
 end