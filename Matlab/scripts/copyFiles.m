function [] = copyFiles(resultsfolder, outputfolder, filenames_to_copy)

    general_outputfolder_copiedFiles = strcat(outputfolder, 'Copied_files/');
    
    if ~exist(outputfolder, 'dir') 
       disp('outputfolder not found');
       disp(outputfolder);
       return 
    end
    if ~exist(general_outputfolder_copiedFiles, 'dir') 
        mkdir(general_outputfolder_copiedFiles);
    end 


    folders = GetSubDirs(resultsfolder); %Get all the individual analysis folders by name
    for n = 1:length(folders)
        %Example of the filenames_to_copy-layout:
%         filenames_to_copy = { ...
%             %'*ReactionForcesPerSleeper*'; ...
%             %'*GaugeNodes*'; ...
%             %'*.png'; ...
%             %'*Foundationdeformations*'; ...
%             %'*MaxStresses*'; ...
%         }';
        folderName = folders(n).name;
        folderLocation = strcat(resultsfolder, folderName);
        outputfolder_copiedFiles = strcat(general_outputfolder_copiedFiles, folderName); %Keep current folder layout
        
        if ~exist(outputfolder_copiedFiles, 'dir') 
            mkdir(outputfolder_copiedFiles);
        end 

        for m = 1:length(filenames_to_copy)           
            file_to_copy = strcat(folderLocation, '/', filenames_to_copy(m));
           [status,message,messageId] = copyfile(file_to_copy{1}, outputfolder_copiedFiles);        
        end
    end

end

