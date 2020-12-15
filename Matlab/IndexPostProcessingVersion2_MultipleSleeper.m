
basefolder = 'O:\AnsysSleeperModel\Results\';

analysisfolder = '20201125_static_Validation_Multiple';
LoadCases = [1;2;3]; %Todo automatic loading of load cases.
%LoadCases = [1;2;3;4];
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
%copyFiles(resultsFolder, outputfolder, filenames_to_copy)

%Get all foldernames/analysis from the resultsfolder
folders = GetSubDirs(resultsFolder);
analysis_names = {folders.name};

while 1 %While loop to be able to collapse code

    analysis_names_multiple = {'1_202_multiple' '2_201_multiple';};


    PostProcess_foundationDisplacements(resultsFolder, analysis_names_multiple, outputfolder, 'full model', LoadCases, 0, -0.15)
    PostProcess_SleeperDisplacements(resultsFolder, analysis_names_multiple, outputfolder, 'full model', LoadCases, 0, -0.15/2)
    PostProcess_reinforcementStrain(resultsFolder, analysis_names_multiple, outputfolder, 'full model', LoadCases, 0)
    PostProcess_reinforcementShear(resultsFolder, analysis_names_multiple, outputfolder, 'full model', LoadCases, 0)
break
end