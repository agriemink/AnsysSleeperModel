function [] = PP_saveMaximumStressesPerSleeperType(dataFolder, analysis_fileNames_201, analysis_fileNames_202, output_directory, loadCaseNumber)
    close all
    SleeperTypes = {'201'; '202'};

    numberOfAnalysis = max(size(analysis_fileNames_201,1), size(analysis_fileNames_202,1));

    if ~isempty(analysis_fileNames_201) && ~isempty(analysis_fileNames_202)

        %init arrays
        zeros_ = zeros(size(SleeperTypes,1),numberOfAnalysis*2);
        S1 = zeros(size(zeros_)); 
        S2 = zeros(size(zeros_)); 
        S3 = zeros(size(zeros_)); 
        SEQV = zeros(size(zeros_)); 
    %     header = zeros(numberOfAnalysis*2); 
    %     subheader = zeros(numberOfAnalysis*2); 

        %% SleeperTypes = rows
       for sleeper = 1:size(SleeperTypes,1); %rows
           if strcmp(SleeperTypes{sleeper},'201') 
              numberOfAnalysis = size(analysis_fileNames_201,1);
           elseif strcmp(SleeperTypes{sleeper},'202')
              numberOfAnalysis = size(analysis_fileNames_202,1);
           end   


           for analysis_index = 1:numberOfAnalysis %Columns
             if strcmp(SleeperTypes{sleeper},'201')
              filename = sprintf(dataFolder, analysis_fileNames_201{analysis_index}, analysis_fileNames_201{analysis_index});
              Names = analysis_fileNames_201;
             elseif strcmp(SleeperTypes{sleeper},'202')
              filename = sprintf(dataFolder, analysis_fileNames_202{analysis_index}, analysis_fileNames_202{analysis_index});
              Names = analysis_fileNames_202;
            end

              % [Node,S1Nm2,S2Nm2,S3Nm2,SEQVNm2,~,~] = importStressesCSV(filename); 
			[ Node,S1Nm2,S2Nm2,S3Nm2,SEQVNm2,~,~,~,~,~] = importStressesCSV(filename);      

             data = [(1:size(Node,1))', Node, S1Nm2, S2Nm2, S3Nm2, SEQVNm2];

             index_min = analysis_index*2-1;
             index_max = analysis_index*2;

             S1(sleeper, index_min) = min(S1Nm2);
             S1(sleeper, index_max) = max(S1Nm2);

             S2(sleeper, index_min) = min(S2Nm2);
             S2(sleeper, index_max) = max(S2Nm2);

             S3(sleeper, index_min) = min(S3Nm2);
             S3(sleeper, index_max) = max(S3Nm2);

             SEQV(sleeper, index_min) = min(SEQVNm2);
             SEQV(sleeper, index_max) = max(SEQVNm2);

             header{1,index_min} = Names{analysis_index};
             subheader{1,index_min} = 'Min';
             subheader{1,index_max} = 'Max';


           end
       end    


        %%Write to xls
        old_directory = cd(output_directory);
        OutputFile = 'Stresses';

        tab = strcat('Load case ', num2str(loadCaseNumber));
        xlswrite(OutputFile,{'SEQV'}, tab, 'A1');
        xlswrite(OutputFile,SleeperTypes, tab, 'A3');
        xlswrite(OutputFile,header, tab, 'B1');
        xlswrite(OutputFile,subheader, tab, 'B2');
        xlswrite(OutputFile,SEQV, tab, 'B3');

        xlswrite(OutputFile,{'S1'}, tab, 'G1');
        xlswrite(OutputFile,SleeperTypes, tab, 'G3');
        xlswrite(OutputFile,header, tab, 'H1');
        xlswrite(OutputFile,subheader, tab, 'H2');
        xlswrite(OutputFile,S1, tab, 'H3');

        xlswrite(OutputFile,{'S2'}, tab, 'M1');
        xlswrite(OutputFile,SleeperTypes, tab, 'M3');
        xlswrite(OutputFile,header, tab, 'N1');
        xlswrite(OutputFile,subheader, tab, 'N2');
        xlswrite(OutputFile,S2, tab, 'N3');

        xlswrite(OutputFile,{'S3'}, tab, 'S1');
        xlswrite(OutputFile,SleeperTypes, tab, 'S3');
        xlswrite(OutputFile,header, tab, 'T1');
        xlswrite(OutputFile,subheader, tab, 'T2');
        xlswrite(OutputFile,S3, tab, 'T3');

        cd(old_directory);
    end
end



