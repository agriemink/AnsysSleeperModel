function [] = PostProcess(analysisfolder, LoadCases, general_outputfolder, analysis_names_general, analysis_names_general_multiple, analysis_names_simple, analysis_names_standard, analysis_names_201, analysis_names_202, data_filenames_optional  )
    
%%Post process 
aantalLoadCases = length(LoadCases);

basefolder = 'O:/AnsysSleeperModel/Results/';
resultsFolder = strcat(basefolder, analysisfolder, '/'); %Where to find results
if ~exist(resultsFolder, 'dir') 
   disp('Resultsfolder not found');
   disp(resultsFolder);
   return 
end
mkdir(general_outputfolder);

%% Gauge widening

    %Standard simulations:
    if exist('analysis_names_general','var')
        PP_saveGaugeWidening(resultsFolder, analysis_names_general, general_outputfolder, LoadCases)
    end 
    
    %Simulations with mulitple sleeper systems:
    if exist('analysis_names_general_multiple','var')
        outputFolder_2 = strcat(general_outputfolder, 'Multiple/');
        mkdir(outputFolder_2);
        PP_saveGaugeWidening(resultsFolder, analysis_names_general_multiple, outputFolder_2, LoadCases)
    end 
   

%% Element convergence:

    if exist('analysis_names_simple','var') && exist('analysis_names_standard','var') 
        for index = 1:aantalLoadCases
            analysis_files_simple = [strcat(resultsFolder, analysis_names_simple, '\', analysis_names_simple, '_Foundationdeformations_', num2str(LoadCases(index)) ,'_Deformations.csv'), analysis_names_simple];

            analysis_files_standard = [strcat(resultsFolder, analysis_names_standard, '\', analysis_names_standard, '_Foundationdeformations_', num2str(LoadCases(index)) ,'_Deformations.csv'), analysis_names_standard];

            PP_reinforcementElementsConvergence(analysis_files_simple, analysis_files_standard, general_outputfolder, num2str(LoadCases(index)));
        end
    end 

%% Maximum stresses:
    
    if exist('analysis_names_201','var') && exist('analysis_names_202','var') 
        for index = 1:aantalLoadCases    
           PP_saveMaximumStressesPerSleeperType(strcat(resultsFolder, '%s/%s_', 'Foundationdeformations', '_', num2str(LoadCases(index)) ,'_Stresses.csv'), analysis_names_201, analysis_names_202, general_outputfolder, num2str(LoadCases(index)));
        end     
    end
%% Maximum stresses per component (material):
     if ~exist('data_filenames_optional','var')
         data_filenames = { ...
            'Rail'; ...
            'WapeningBoven'; ...
            'WapeningOnder'; ...
            'SleeperStressesKunststof';...
            'Rughellingplaten_L';...
            'Rughellingplaten_R';...
         };
     else 
       data_filenames = data_filenames_optional; 
     end
        
     if exist('analysis_names_general','var')
        t = 'PP_saveStressesPerComponent' 
        PP_saveStressesPerComponent(strcat(resultsFolder, '%s/%s_%s_%s_Stresses.csv'), data_filenames, analysis_names_general, general_outputfolder, LoadCases)
     end
   
end

