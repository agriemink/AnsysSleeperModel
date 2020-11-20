
basefolder = 'O:\AnsysSleeperModel\Results\';

analysisfolder = '20201119_static_Validation_3PointBending';
%LoadCases = [1;2;3;4;5;6;7]; %Todo automatic loading of load cases.
LoadCases = [1;2;3;4];
outputfolder = strrep([basefolder '/MatlabResults/' analysisfolder ' - ' date '/'], '.', ','); %Remove points as they don't work well.

resultsFolder = [basefolder analysisfolder '/'];

if ~exist(resultsFolder, 'dir') 
   disp('Resultsfolder not found');
   disp(resultsFolder);
   return 
end
if ~exist(outputfolder, 'dir') 
    mkdir(outputfolder);
end 
addpath('scripts')
addpath('O:\AnsysSleeperModel\Matlab\scripts\')

% Copy files from the Ansys-folder
filenames_to_copy = { ...
   '*.csv'; ...
   '*.png'; ...
   '*.xlsx'; ...
}';
copyFiles(resultsFolder, outputfolder, filenames_to_copy)

%Get all foldernames/analysis from the resultsfolder
folders = GetSubDirs(resultsFolder);
analysis_names = {folders.name};

while 1 %While loop to be able to collapse code
    analysis_names_PE_3Pbending = {'1_201_250' '2_201_300' '3_201_400' '4_201_650';};
    analysis_names_HDPE_3Pbending = {'5_202_450' '6_202_650' '7_202_900' '8_202_1080' '9_202_1250';};

    analysis_names_Emod_201 = {'1_201_250' '2_201_300' '3_201_400' '4_201_650';};
    analysis_names_Emod_202 = {'5_202_450' '6_202_650' '7_202_900' '8_202_1080' '9_202_1250';};
    analysis_names_Emod = [analysis_names_Emod_201 analysis_names_Emod_202];

    analysis_names_K = {'10_202_C=0,02' '11_202_C=0,05' '12_202_C=0,1' '13_202_C=0,1385' '14_202_C=0,2';};

    %analysis_names_dekking = {'202_Dekking12,5';'202_Dekking13,5';'202_Dekking14,5';'202_Dekking15,5';'202_Dekking16,5';};
    %PostProcess_foundationDisplacements(resultsFolder, analysis_names_dekking, outputfolder, 'different reinforcement coverage', LoadCases, 0, -0.15)

    % 
    PostProcess_SleeperDisplacements(resultsFolder, analysis_names_HDPE_3Pbending, outputfolder, '3-point bending 202', LoadCases, 0, -0.15)
    PostProcess_SleeperDisplacements(resultsFolder, analysis_names_PE_3Pbending, outputfolder, '3-point bending 201', LoadCases, 0, -0.15)
    % 
    %PostProcess_foundationDisplacements(resultsFolder, analysis_names_Emod_201, outputfolder, '201', LoadCases, 0, -0.15)
    %PostProcess_foundationDisplacements(resultsFolder, analysis_names_Emod_202, outputfolder, '202', LoadCases, 0, -0.15)
    %PostProcess_foundationDisplacements(resultsFolder, analysis_names_Emod, outputfolder, 'different E', LoadCases, 0, -0.15)
    % 
    % PostProcess_SleeperDisplacements(resultsFolder, analysis_names_Emod, outputfolder, 'different E', LoadCases, 0, -0.15/2)

    %PostProcess_reinforcementStrain(resultsFolder, analysis_names_Emod, outputfolder, 'different E', LoadCases)
    %PostProcess_reinforcementShear(resultsFolder, analysis_names_Emod_201, outputfolder, '201', LoadCases)
    %PostProcess_reinforcementShear(resultsFolder, analysis_names_Emod_202, outputfolder, '202', LoadCases)
    %PostProcess_SleeperDisplacements(resultsFolder, analysis_names_K, outputfolder, 'different K', LoadCases, 0, -0.15/2)
    %PostProcess_reinforcementStrain(resultsFolder, analysis_names_K, outputfolder, 'different K', LoadCases)
break
end