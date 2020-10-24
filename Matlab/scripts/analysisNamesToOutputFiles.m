function [ output_args ] = analysisNamesToOutputFiles(resultFolder, analysisNames, outputFileName, LoadCase )
    
    folder_simple = strcat(commonFolder, analysis_simple, '\');
    folder = strcat(commonFolder, analysis, '\');

 filename_fundering = strcat(folder_simple{analysis_nr}, analysis_simple{analysis_nr}, '_Foundationdeformations_', num2str(loadCase) ,'_Deformations.csv');
    
    folder = strcat(commonFolder, analysis, '\');




end

