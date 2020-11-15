
basefolder = 'O:\AnsysSleeperModel\Results\';

analysisfolder = '20201114_static_Validation_';
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


%Get all foldernames/analysis from the resultsfolder
folders = GetSubDirs(resultsFolder);
analysis_names = {folders.name};

analysis_names_PE_3Pbending = {'1_201_250'; '2_201_400';};
analysis_names_HDPE_3Pbending = {'3_202_650'; '4_202_1250'; '5_202_900';};

analysis_names_Emod_201 = {'1_201_250';'2_201_400'};
analysis_names_Emod_202 = {'3_202_650';'5_202_900';'4_202_1250';};
analysis_names_Emod = [analysis_names_Emod_201; analysis_names_Emod_202];

analysis_names_K = {'6_202_C=0,02' '7_202_C=0,05' '8_202_C=0,1' '9_202_C=0,1385';};

%analysis_names_dekking = {'202_Dekking12,5';'202_Dekking13,5';'202_Dekking14,5';'202_Dekking15,5';'202_Dekking16,5';};
%PostProcess_foundationDisplacements(resultsFolder, analysis_names_dekking, outputfolder, 'different reinforcement coverage', LoadCases, 0, -0.15)


PostProcess_foundationDisplacements(resultsFolder, analysis_names_HDPE_3Pbending, outputfolder, '3-point bending 202', LoadCases, 0, -0.15)
PostProcess_foundationDisplacements(resultsFolder, analysis_names_PE_3Pbending, outputfolder, '3-point bending 201', LoadCases, 0, -0.15)

PostProcess_foundationDisplacements(resultsFolder, analysis_names_Emod, outputfolder, 'different E', LoadCases, 0, -0.15)

PostProcess_SleeperDisplacements(resultsFolder, analysis_names_Emod, outputfolder, 'different E', LoadCases, 0, -0.15/2)
PostProcess_SleeperDisplacements(resultsFolder, analysis_names_K, outputfolder, 'different K', LoadCases, 0, -0.15/2)

PostProcess_reinforcementStrain(resultsFolder, analysis_names_Emod, outputfolder, 'different E', LoadCases)
PostProcess_reinforcementStrain(resultsFolder, analysis_names_K, outputfolder, 'different K', LoadCases)
