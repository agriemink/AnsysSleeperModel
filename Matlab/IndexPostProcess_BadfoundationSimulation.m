%%Post process 
clear;clc;close all;

basefolder = 'O:/AnsysSleeperModel/Results/';

%% Input:
analysisfolder = '\20201028_static_ResultsMultiple_';
LoadCases = [1;2];
outputfolder = strcat('O:/AnsysSleeperModel/Results/ResultsBadFoundationMultiple/', analysisfolder, ' - ', date, '/');

resultsfolder = strcat(basefolder, analysisfolder, '/'); %Where to find results


mkdir(outputfolder)
addpath('./sortStruct');
addpath(genpath(pwd))


outputfolder_copiedFiles = strcat(outputfolder, 'Copied_files/');
mkdir(outputfolder_copiedFiles);
folders = GetSubDirs(resultsfolder); %Get all the individual analysis folders by name
for n = 1:length(folders)
    filenames_to_copy = { ...
        %'*ReactionForcesPerSleeper*'; ...
        %'*GaugeNodes*'; ...
        %'*.png'; ...
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
%Temporary solution to allows non-parametric names to be used as well
% A = 1, C = 1 cases.
analysis_names_2 = {};
analysis_names_2(1,:) = {'202_HDPE_foundation_0.333_100' 0.333 100};
analysis_names_2(2,:) = {'202_HDPE_foundation_0.333_1000' 0.333 1000};
analysis_names_2(3,:) = {'202_HDPE_foundation_0.5_100' 0.5 100};
analysis_names_2(4,:) = {'202_HDPE_foundation_0.5_1000' 0.5 1000};
analysis_names_2(5,:) = {'3SleeperExample' 0.333 1};
analysis_names_2(6,:) = {'3SleeperExample' 0.5 1};
analysis_names_2(7,:) = {'3SleeperExample' 1 1};
analysis_names_2(8,:) = {'3SleeperExample' 1 100};
analysis_names_2(9,:) = {'3SleeperExample' 1 1000};

%wanted_a = [1 0.5 0.333];
%wanted_c = [1 100 1000];
for loadCase_index = 1:size(LoadCases,1)      
    LoadCase_name = sprintf('LoadCase%d', LoadCases(loadCase_index));
    plotData = {};
    
    for analysis_index = 1:size(analysis_names_2,1)
        analysis_name = createSafeAnalysisName(analysis_names_2{analysis_index, 1});
        a = analysis_names_2{analysis_index, 2};
        c_factor = analysis_names_2{analysis_index, 3};

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
            plotData.(c_name).y(entry_id) = max(gaugeWideningResults.(LoadCase_name).(analysis_name).gaugeWidening)*1000; %Convert to mm
        end
    end

    
    if ~isempty(plotData)
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
        xlabel('Center size fraction (A) of sleeper length [-]');
        hold off

        filename = strrep(sprintf('%s%s - %s ', outputfolder, 'gaugeWideningOverviewPerCfactor', LoadCase_name), '.', ',');
        saveas(gcf, filename, 'png');
        saveas(gcf, filename ,'epsc');
        saveas(gcf, filename ,'m');
    end
end

    
  
    
