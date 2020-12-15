function [] = PostProcess_reinforcementStrain(analysisFolder, analysis_fileNames, output_directory, figureName, LoadCases, X_coord)

%
%Result-array: 1 = minimale waarde (onder belasting)
%              2 = maximale waarde (midden van ligger)    

% xlswrite

Excel_filename = ['sleeperReinforcementStrains_' figureName '.xlsx'];

gravitiy_deformation_set = 0;

for index = 1:length(LoadCases)
    loadCase = LoadCases(index)
   
    tab = strcat('Load case ', num2str(loadCase));
    
    figure;
    set(gcf,'Position',[100 100 700 500]) %Adjust figure size
    hold all; 
    %% 
    for analysis_nr = 1:length(analysis_fileNames)
        analysis_fileName = analysis_fileNames{analysis_nr};
        [ filename_deformation_boven, filename_stresses_boven ] = GetAnalysisdata(analysisFolder, analysis_fileNames{analysis_nr}, loadCase, 'WapeningBoven');
        [ filename_deformation_onder, filename_stresses_onder ] = GetAnalysisdata(analysisFolder, analysis_fileNames{analysis_nr}, loadCase, 'WapeningOnder');
        %X_coord = '';
        Y_coord = '';
        
        foundationNodes_boven = getStresses(filename_deformation_boven, filename_stresses_boven, X_coord, Y_coord);
        foundationNodes_onder = getStresses(filename_deformation_onder, filename_stresses_onder, X_coord, Y_coord);
                     
        %Get maximum strain value per z-coordinate
        z_coordinates = unique([foundationNodes_boven.Z]);
        strain_values_max = zeros(length(z_coordinates), 1);
        strain_values_min = zeros(length(z_coordinates), 1);
        for z_index = 1:length(z_coordinates)
            z_coordinate = z_coordinates(z_index);
            foundationNodesForThisZ_boven = foundationNodes_boven(abs([foundationNodes_boven.Z] - z_coordinate) < 0.0001, :); 
            foundationNodesForThisZ_onder = foundationNodes_onder(abs([foundationNodes_onder.Z] - z_coordinate) < 0.0001, :); 
            
            strain_values_max(z_index) = max([[foundationNodesForThisZ_boven.EquivalentStrain] [foundationNodesForThisZ_onder.EquivalentStrain]]);
            strain_values_min(z_index) = min([[foundationNodesForThisZ_boven.EquivalentStrain] [foundationNodesForThisZ_onder.EquivalentStrain]]);
        end

       if loadCase == 1
           gravitiy_deformation_set = 1;
           gravitiy_deformation_max(analysis_nr) = struct('StrainGravity', strain_values_max); 
           gravitiy_deformation_min(analysis_nr) = struct('StrainGravity', strain_values_min); 
           plot(z_coordinates, strain_values_max, 'DisplayName', strrep(['Max strain ' analysis_fileName], '_', ' '));
           Excel_data_max = strain_values_max;
           Excel_data_min = strain_values_min;
        elseif gravitiy_deformation_set == 1
           plot(z_coordinates, strain_values_max - [gravitiy_deformation_max(analysis_nr).StrainGravity], 'DisplayName', strrep(['Max strain ' analysis_fileName], '_', ' '));
           Excel_data_max = strain_values_max - [gravitiy_deformation_max(analysis_nr).StrainGravity];
           Excel_data_min = strain_values_min - [gravitiy_deformation_min(analysis_nr).StrainGravity];
        else
           plot(z_coordinates, strain_values_max, 'DisplayName', strrep(['Max strain ' analysis_fileName], '_', ' '));
           Excel_data_max = strain_values_max;
           Excel_data_min = strain_values_min;
       end

        if ~isempty(Excel_data_min) && ~isempty(Excel_data_max) 
            old_directory = cd(output_directory);
            % skip 1 because of the first z-coordinate column
            xlswrite(Excel_filename, strcat({analysis_fileName}, ' Min'), tab, strcat(getExcelColumn(analysis_nr*2), '1'));
            xlswrite(Excel_filename, strcat({analysis_fileName}, ' Max'), tab, strcat(getExcelColumn(analysis_nr*2+1), '1'));
            xlswrite(Excel_filename, Excel_data_min, tab, strcat(getExcelColumn(analysis_nr*2), '2'));  
            xlswrite(Excel_filename, Excel_data_max, tab, strcat(getExcelColumn(analysis_nr*2+1), '2'));
            cd(old_directory)
        end
    end
    
    
    old_directory = cd(output_directory);
    if ~isempty(z_coordinates)
        xlswrite(Excel_filename, {'Z-coordinate'}, tab, 'A1');
        xlswrite(Excel_filename,  z_coordinates', tab, 'A2');
    end
    
    hold off
    titleText = sprintf('Reinforcement strain %s at X=%g Y =%g ', figureName, X_coord, Y_coord);
    title(titleText);
    xlabel('Z-coordinate [m]')
    ylabel('strain [-]')
    legend('Location', 'best')
    filename = [output_directory strrep(sprintf('%s %i', titleText, loadCase),'.',',')];
    saveas(gcf,filename,'png');
    saveas(gcf,filename,'eps');
    saveas(gcf,filename,'m');
    close;
    
    cd(old_directory)
end

