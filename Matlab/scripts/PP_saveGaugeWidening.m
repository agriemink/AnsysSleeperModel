function [results] = PP_saveGaugeWidening(dataFolder, analysis_fileNames, output_directory, LoadCases)
    format longg
    
    %%Post process 
    resultsFolder = dataFolder;
    outputFolder = output_directory;
    mkdir(outputFolder)

    addpath('./sortStruct');

    %% Element convergence:

    analysis_names = analysis_fileNames;

    %analysis_names = {'202_HDPE_foundation_0.5_2'}; %Only for debug purposes
    for loadCase_index = 1:size(LoadCases,1)
        analysis_files_foundation = strcat(resultsFolder, analysis_names, '\', analysis_names, '_Foundationdeformations_', num2str(LoadCases(loadCase_index)) ,'_Deformations.csv');
        analysis_files_rail = strcat(resultsFolder, analysis_names, '\', analysis_names, '_GaugeNodes_', num2str(LoadCases(loadCase_index)) ,'_Deformations.csv');
        
        loadCase_name = sprintf('LoadCase%d', LoadCases(loadCase_index));
    
        for analysis_index = 1:size(analysis_names,2)
            analysis_name = createSafeAnalysisName(analysis_names{analysis_index});
            results.(loadCase_name).(analysis_name) = [];
            
            %% Gauge widening:
            GaugeNodes = getGaugeWidening(analysis_files_rail{analysis_index});
                      
            %results.(loadCase_name).results(analysis_index) = struct('a', a, 'c_factor', c_factor, 'gaugeWidening', max([GaugeNodes.gaugeChange]));
            

            results.(loadCase_name).(analysis_name) = [results.(loadCase_name).(analysis_name), struct('X_coord', [GaugeNodes.X], 'gaugeWidening', [GaugeNodes.gaugeChange], 'gaugeChange_L', [GaugeNodes.gaugeChange_L], 'gaugeChange_R', [GaugeNodes.gaugeChange_R] )];
            
            %plotAndSave([GaugeNodes.X], [GaugeNodes.gaugeChange_L]*1000, sprintf('Z-deformation of left gauge nodes %s.', strrep(analysis_names{analysis_index}, '_', ' ')), 'X-coordinate [m]', 'Sideways movement [mm]', 0, LoadCases(loadCase_index), outputFolder)
            %plotAndSave([GaugeNodes.X], [GaugeNodes.gaugeChange_R]*1000, sprintf('Z-deformation of right gauge nodes %s.', strrep(analysis_names{analysis_index}, '_', ' ')), 'X-coordinate [m]', 'Sideways movement [mm]', 0, LoadCases(loadCase_index), outputFolder)
            calculatedGaugeWidening = [GaugeNodes.gaugeChange_L]-[GaugeNodes.gaugeChange_R];
            plotAndSave([GaugeNodes.X], calculatedGaugeWidening*1000, sprintf('Gauge change between both rails %s.', strrep(analysis_names{analysis_index}, '_', ' ')), 'X-coordinate [m]', 'Gauge change [mm]', 0, LoadCases(loadCase_index), outputFolder)
            
            %% Foundation deformation at X = 0
            foundationNodes = getFoundationDisplacement(analysis_files_foundation{analysis_index}, 0);
            
            plotAndSave([foundationNodes.Z], [foundationNodes.Uy]*1000, sprintf('vertical deformation of foundation %s.', strrep(analysis_names{analysis_index}, '_', ' ')), 'Z-coordinate [m]', 'deformation [mm]', 0, LoadCases(loadCase_index), outputFolder)

            close all;
        end 
        close all;
        

        if exist('results', 'var') == 1
            fn = fieldnames(results.(loadCase_name));
            figure;
            hold all
            title(strcat('GaugeWidening: ', loadCase_name));
            for k=1:numel(fn)
                disp(fn{k})           

                data_x = [results.(loadCase_name).(fn{k}).X_coord];
                data_y = [results.(loadCase_name).(fn{k}).gaugeWidening]*1000; %Convert to mm

    %           [sortedStructure.a]
    %           size([sortedStructure.a])
    %           [sortedStructure.gaugeWidening]
    %           size([sortedStructure.gaugeWidening])

                if size(data_y,2) == size(data_x,2) 
                    plot(data_x(1:size(data_y,2)), data_y);
                end 

            end
            legend(strrep(fn, '_', '.')) %sets the labels using a cell array of character vectors, a string array, or a character matrix, such as legend({'Jan','Feb','Mar'}).
            ylabel('Maximal gauge change between both rails. [mm]');
            xlabel('X-coordinate [m]');
            hold off

            filename = strrep(sprintf('%s/%s - %s ', outputFolder, loadCase_name, '_gaugeWideningOverview'), '.', ',');
            saveas(gcf, filename, 'png');
            saveas(gcf, filename ,'epsc');
            saveas(gcf, filename ,'m');
            %matlab2tikz(strcat(filename, 'tex'));
        end
    end
    
    %% Create gauge widening excel:
    alfabet = ['ABCDEFGHIJKLMNOPQRSTUVWXYZ'];
    for loadCase_index = 1:size(LoadCases,1)
        if exist('results', 'var') == 1
            loadCase_name = sprintf('LoadCase%d', LoadCases(loadCase_index));

            filename = strrep(sprintf('%s/%s ', outputFolder, 'gaugeWideningOverview'), '.', ',');
            tab = 'gauge widening';
            if loadCase_index == 1
                xlswrite(filename, {'Load case:'}, tab , 'A2');
            end

            row = num2str(loadCase_index + 2);
            xlswrite(filename, {loadCase_name}, tab , strcat('A', row));
            for analysis_index = 1:size(analysis_names, 2)
                analysis_name = createSafeAnalysisName(analysis_names{analysis_index});
                column_index = (analysis_index-1) * 3 + 2;


                column_letter_prefix = '';
                if column_index > size(alfabet,2)
                    column_letter_prefix = alfabet(floor(column_index/size(alfabet,2)));
                end
                column_letter = strcat(column_letter_prefix, alfabet(max(1, mod(column_index, size(alfabet,2)+ 1))));

                if loadCase_index == 1
                    %Add headers:
                    xlswrite(filename, {analysis_name}, tab , strcat(column_letter, '1'));
                    xlswrite(filename, {'Gauge widening [mm]', 'Change Left [mm]', 'Right [mm]'}, tab , strcat(column_letter, '2'));
                end
            
           
                [~, maxGaugeIndex] = max(abs(results.(loadCase_name).(analysis_name).gaugeWidening));
                maxGaugeChange = results.(loadCase_name).(analysis_name).gaugeWidening(maxGaugeIndex)*1000; %convert to mm
                deltaLeft = results.(loadCase_name).(analysis_name).gaugeChange_L(maxGaugeIndex)*1000; %convert to mm
                deltaRight = results.(loadCase_name).(analysis_name).gaugeChange_R(maxGaugeIndex)*1000; %convert to mm

                xlswrite(filename, {maxGaugeChange, deltaLeft, deltaRight}, tab , strcat(column_letter, row));
            end
        end
    end
    
  
    %% Create overview of parameters:
   %TODO
    
end


  
    
