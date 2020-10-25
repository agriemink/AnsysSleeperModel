%%Post process 
clear;clc;close all;

basefolder = 'O:/AnsysSleeperModel/Results/';

%% Input:
analysisfolder = '20200527_static_BadFoundations';
LoadCases = [1;2;3;4;5;6;7];
outputfolder = strcat('O:/Afstuderen/DataAnalyse/MatlabPostProcess/ResultsBadFoundation/', analysisfolder, ' - ', date, '/');

resultsfolder = strcat(basefolder, analysisfolder, '/'); %Where to find results


mkdir(outputfolder)
addpath('./sortStruct');
addpath(genpath(pwd))


outputfolder_copiedFiles = strcat(outputfolder, 'Copied_files/');
mkdir(outputfolder_copiedFiles);
folders = GetSubDirs(resultsfolder); %Get all the individual analysis folders by name
for n = 1:length(folders)
    filenames_to_copy = { ...
        '*ReactionForcesPerSleeper*'; ...
        %'*GaugeNodes*'; ...
        '*.png'; ...
    }';

    for m = 1:length(filenames_to_copy)    
        file_to_copy = strcat(resultsfolder, folders(n).name, '/', filenames_to_copy(m));
        copyfile(file_to_copy{1}, outputfolder_copiedFiles);        
    end
end


%% Gauge widening

analysis_names = {folders.name};
gaugeWideningResults = PP_saveGaugeWidening(resultsfolder, analysis_names, outputfolder, LoadCases);

%% custom graph:

for loadCase_index = 1:size(LoadCases,1)      
    LoadCase_name = sprintf('LoadCase%d', LoadCases(loadCase_index));
    
    i = 0;
    plotData = {};
    for a = 0:0.001:1
       for c_factor = 1:0.1:10
          analysis_name = createSafeAnalysisName(strcat('202_HDPE_foundation_', num2str(a), '_', num2str(c_factor)));
         
          if isfield(gaugeWideningResults.(LoadCase_name), analysis_name) == 1              
              i = i + 1;
              analysis_name_exists = isfield(gaugeWideningResults.(LoadCase_name), analysis_name);
              
              c_name = strcat('C', strrep(num2str(c_factor), '.', '_')); %Turn underscore back into decimal point.
              
              if isfield(plotData, c_name) == 1 && isfield(plotData.(c_name), 'x') == 1 %Test if the c_factor is already used before
                entry_id = length(plotData.(c_name).x) + 1;
              else
                entry_id = 1; 
                plotData.(c_name).x = [];
                plotData.(c_name).y = [];
                plotData.(c_name).name = c_factor;
              end
              
              plotData.(c_name).x(entry_id) = a;
              plotData.(c_name).y(entry_id) = max(gaugeWideningResults.(LoadCase_name).(analysis_name).gaugeWidening);
          end
       end
    end
    
    figure;
    hold all;
    title(strcat('GaugeWidening: ', LoadCase_name));
    fn = fieldnames(plotData);
    for n = 1:length(fn)
        c_name = char(fn(n));
        plot([plotData.(c_name).x], [plotData.(c_name).y]);
    end
    legend(strrep(fn, '_', '.')); %sets the labels using a cell array of character vectors, a string array, or a character matrix, such as legend({'Jan','Feb','Mar'}).
    ylabel('Maximal gauge change between both rails. [mm]');
    xlabel('Center size fraction (A) of sleeper lenght [-]');
    hold off

    filename = strrep(sprintf('%s%s - %s ', outputfolder, 'gaugeWideningOverviewPerCfactor', LoadCase_name), '.', ',');
    saveas(gcf, filename, 'png');
    saveas(gcf, filename ,'epsc');
    saveas(gcf, filename ,'m');
end

    
  
    
