function [] = combineResultsInSingleFile( filename, output_directory, loadCases)

    %% Load files
    [~,S1Nm2,S2Nm2,S3Nm2,SEQVNm2,~,~] = importStressesCSV(filename); 
    [Node, LocX, LocY, LocZ, UXm, UYm, UZm] = importDeformationCSV(filename); 
     
    %% combine data
    data = [Node, LocX, LocY, LocZ, UXm, UYm, UZm, S1Nm2, S2Nm2, S3Nm2, SEQVNm2];
    
    %% Save to xls
    OutputFile = strcat(output_directory,filename);
    
    for loadCaseIndex = 0:size(loadCases)  
    
        tab = strcat('Load case ', num2str(loadCases(loadCaseIndex))); 

        %Header
        xlswrite(OutputFile, ['Node', 'LocX', 'LocY', 'LocZ', 'UXm', 'UYm', 'UZm', 'S1Nm2', 'S2Nm2', 'S3Nm2', 'SEQVNm2'], tab, strcat('A1')); 
        
        for row = 1:size(Node) %Rows
           row = row + 1;
          
           xlswrite(OutputFile, data(row), tab,strcat('A', num2str(row)));
        end
    end
end

