
basefolder = 'O:\AnsysSleeperModel\Results\';

analysisfolder = '20201102_static_Validation_';
LoadCases = [1;2;3;4];
outputfolder = strrep([basefolder '/Results/' analysisfolder ' - ' date '/'], '.', ','); %Remove points as they don't work well.

resultsFolder = [basefolder analysisfolder '/'];

if ~exist(resultsFolder, 'dir') 
   disp('Resultsfolder not found');
   disp(resultsFolder);
   return 
end
if ~exist(outputfolder, 'dir') 
    mkdir(outputfolder);
end 

%Get all foldernames/analysis from the resultsfolder
%folders = GetSubDirs(resultsfolder);
%analysis_names = {folders.name};


analysis_names_PE_3Pbending = {'PE_2D_f_7.69E-02_1000';'PE_2D_10K_f_7.69E-02_1000';'PE_2D_f_7.69E-02_10000';'PE_2D_10K_f_7.69E-02_10000';'PE_2D_f_7.69E-02_100';'PE_2D_10K_f_7.69E-02_100';};
analysis_names_HDPE_3Pbending = {'HDPE_2D_f_7.69E-02_1000';'HDPE_2D_10K_f_7.69E-02_1000';'HDPE_2D_f_7.69E-02_10000';'HDPE_2D_10K_f_7.69E-02_10000';'HDPE_2D_f_7.69E-02_100';'HDPE_2D_10K_f_7.69E-02_100';};

analysis_names_Emod_201 = {'201_250';'201_400'};
analysis_names_Emod_202 = {'202_1250';'202_650';'202_900';};
analysis_names_Emod = [analysis_names_Emod_201; analysis_names_Emod_202];
analysis_names_dekking = {'202_Dekking12,5';'202_Dekking13,5';'202_Dekking14,5';'202_Dekking15,5';'202_Dekking16,5';};

PostProcess_foundationDisplacements(resultsFolder, analysis_names_HDPE_3Pbending, outputfolder, '3-point bending 202', LoadCases, 0, -0.15)
PostProcess_foundationDisplacements(resultsFolder, analysis_names_PE_3Pbending, outputfolder, '3-point bending 201', LoadCases, 0, -0.15)

PostProcess_foundationDisplacements(resultsFolder, analysis_names_Emod, outputfolder, 'different E', LoadCases, 0, -0.15)
PostProcess_foundationDisplacements(resultsFolder, analysis_names_dekking, outputfolder, 'different reinforcement coverage', LoadCases, 0, -0.15)
