function [ filename_deformation, filename_stresses ] = GetAnalysisdata(baseFolder, analysis_fileName, loadCase, elementName)

    specificAnalysisFolder = strcat(baseFolder, analysis_fileName);

    if exist(specificAnalysisFolder,'dir')
        old_folder = cd(specificAnalysisFolder);
     
        loadCase_str = num2str(loadCase);
        
        files    = dir(['*' elementName '*' loadCase_str '*.csv']);
        cd(old_folder)
        % Get a logical vector that tells which is a directory.
        % Extract only those that are directories.

        filenames = {files.name};
        if length(filenames) == 2

            deformationIndex = strfind(filenames, 'Deformation');
            stressIndex = strfind(filenames, 'Stresses');
            
            for filenameIndex = 1:length(filenames)
                
                if isempty(stressIndex{1,filenameIndex}) && ~isempty(deformationIndex{1,filenameIndex}) && deformationIndex{1,filenameIndex} > 0
                    filename_deformation = [specificAnalysisFolder '/' filenames{filenameIndex}];
                    
                elseif isempty(deformationIndex{1,filenameIndex}) && ~isempty(stressIndex{1,filenameIndex}) && stressIndex{1,filenameIndex} > 0
                    filename_stresses = [specificAnalysisFolder '/' filenames{filenameIndex}];
                else
                    disp 'no correct filesnames found.'
                end
            end
        else
            disp 'not exactly 2 files found. Filenames:'
            filenames
        end
    elseif exist(baseFolder,'dir')
        disp 'folder not found:'
        specificAnalysisFolder
        possbileFolders = dir(baseFolder)
    else
        disp 'basefolder not found:'
        baseFolder
        specificAnalysisFolder
    end
end

