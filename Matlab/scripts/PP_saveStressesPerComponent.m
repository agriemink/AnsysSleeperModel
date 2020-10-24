function [] = PP_saveStressesPerComponent(dataFolder, data_filenames, analysis_fileNames, output_directory, loadCases)

    %

    
    numberOfAnalysis = size(analysis_fileNames,1);
    numberOfMaterials = size(data_filenames,1);    
    
    %Index parameters
    header    = cell(1, numberOfMaterials*2);
    header(:) = {''};
    subheader = cell(1, numberOfMaterials*2);
    stress_names = cell(1, 4);
   % StressesPerAnalysis = cell(1, numberOfMaterials*2);
   % Stresses = cell(1, numberOfAnalysis);
    
   %%Write to xls
   OutputFile = strcat(output_directory, 'StressesPerMaterial');
   %delete old file
   delete(strcat(OutputFile, '.xls'));
        
    for loadCaseindex = 1:size(loadCases,1) 
        loadCaseNumber = loadCases(loadCaseindex)
        for  analysis_index = 1:numberOfAnalysis %Rows
                
            for material_index = 1:numberOfMaterials
                %Materials; e.g. rughellingplaat, kunststof, rail... 
                filename = sprintf(dataFolder, analysis_fileNames{analysis_index}, analysis_fileNames{analysis_index}, data_filenames{material_index}, num2str(loadCaseNumber) )
                
                [~,S1Nm2,S2Nm2,S3Nm2,SEQVNm2,~,~] = importStressesCSV(filename); 

                stress_names = {{'SEQV [N/m2]'}; {'S1 [N/m2]'}; {'S2 [N/m2]'}; {'S3 [N/m2]'}};
                StressesPerAnalysis{material_index, :} = {{min(SEQVNm2), max(SEQVNm2)}, {min(S1Nm2), max(S1Nm2)}, {min(S2Nm2), max(S2Nm2)}, {min(S3Nm2), max(S3Nm2)}};


                header{1, material_index*2-1} = data_filenames{material_index};
                subheader{1, material_index*2-1} = 'min';
                subheader{1, material_index*2} = 'max';


            end

            Stresses{analysis_index, :} = StressesPerAnalysis;

        end
    
    
        
    


        for stress_index = 1:size(stress_names,1)
            base_row = (stress_index-1)*(numberOfAnalysis+4) + 1;

            disp 'tabname:';
            tab = strcat('Load case ', num2str(loadCaseNumber)) 

            xlswrite(OutputFile, stress_names{stress_index, :}, tab, strcat('A', num2str(base_row))); 
            xlswrite(OutputFile, header, tab, strcat('B', num2str(base_row)));
            xlswrite(OutputFile, subheader, tab, strcat('B', num2str(base_row+1)));

            for analysis_index = 1:numberOfAnalysis %Rows
                row = base_row + analysis_index + 1;

                for material_index = 1:numberOfMaterials
                    row_data{1, material_index*2-1} = Stresses{analysis_index, :}{material_index}{stress_index}{1};
                    row_data{1, material_index*2} = Stresses{analysis_index, :}{material_index}{stress_index}{2};         
                end

               xlswrite(OutputFile, row_data, tab,strcat('B', num2str(row)));
            end

            xlswrite(OutputFile, analysis_fileNames, tab, strcat('A', num2str(base_row+2))); 

        end 
    end
    
end

