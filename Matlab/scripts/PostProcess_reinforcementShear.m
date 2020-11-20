function [] = PostProcess_reinforcementShear(analysisFolder, analysis_fileNames, output_directory, figureName, LoadCases)

%
%Result-array: 1 = minimale waarde (onder belasting)
%              2 = maximale waarde (midden van ligger)    

% xlswrite

Excel_filename = ['sleeperReinforcementShearStresses_' figureName '.xlsx'];

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
        X_coord = '';
        Y_coord = '';
        
        foundationNodes_boven = getStresses(filename_deformation_boven, filename_stresses_boven, X_coord, Y_coord);
        foundationNodes_onder = getStresses(filename_deformation_onder, filename_stresses_onder, X_coord, Y_coord);
                     
        %Get maximum shear value per z-coordinate
        z_coordinates = unique([foundationNodes_boven.Z]);
        shear_values_max = zeros(length(z_coordinates), 1);
        shear_values_min = zeros(length(z_coordinates), 1);
        for z_index = 1:length(z_coordinates)
            z_coordinate = z_coordinates(z_index);
            foundationNodesForThisZ_boven = foundationNodes_boven(abs([foundationNodes_boven.Z] - z_coordinate) < 0.0001, :); 
            foundationNodesForThisZ_onder = foundationNodes_onder(abs([foundationNodes_onder.Z] - z_coordinate) < 0.0001, :); 
            
            shear_values_max(z_index) = max([[foundationNodesForThisZ_boven.YZ] [foundationNodesForThisZ_onder.YZ]]);
            shear_values_min(z_index) = min([[foundationNodesForThisZ_boven.YZ] [foundationNodesForThisZ_onder.YZ]]);
        end

       if loadCase == 1
           gravitiy_deformation_set = 1;
           gravitiy_deformation_max(analysis_nr) = struct('ShearGravity', shear_values_max); 
           gravitiy_deformation_min(analysis_nr) = struct('ShearGravity', shear_values_min); 
           plot(z_coordinates, shear_values_max, 'DisplayName', strrep(['Max shear ' analysis_fileName], '_', ' '));
           Excel_data_max = shear_values_max;
           Excel_data_min = shear_values_min;
        elseif gravitiy_deformation_set == 1
           plot(z_coordinates, shear_values_max - [gravitiy_deformation_max(analysis_nr).ShearGravity], 'DisplayName', strrep(['Max shear ' analysis_fileName], '_', ' '));
           Excel_data_max = shear_values_max - [gravitiy_deformation_max(analysis_nr).ShearGravity];
           Excel_data_min = shear_values_min - [gravitiy_deformation_min(analysis_nr).ShearGravity];
        else
           plot(z_coordinates, shear_values_max, 'DisplayName', strrep(['Max shear ' analysis_fileName], '_', ' '));
           Excel_data_max = shear_values_max;
           Excel_data_min = shear_values_min;
        end

        old_directory = cd(output_directory);
        % skip 1 because of the first z-coordinate column
        xlswrite(Excel_filename, strcat({analysis_fileName}, ' Min'), tab, strcat(getExcelColumn(analysis_nr*2), '1'));
        xlswrite(Excel_filename, strcat({analysis_fileName}, ' Max'), tab, strcat(getExcelColumn(analysis_nr*2+1), '1'));
        xlswrite(Excel_filename, Excel_data_min, tab, strcat(getExcelColumn(analysis_nr*2), '2'));  
        xlswrite(Excel_filename, Excel_data_max, tab, strcat(getExcelColumn(analysis_nr*2+1), '2'));
        cd(old_directory)
    end
    
    old_directory = cd(output_directory);
    xlswrite(Excel_filename, {'Z-coordinate'}, tab, 'A1');
    xlswrite(Excel_filename,  z_coordinates', tab, 'A2');

    hold off
    titleText = sprintf('Reinforcement shear stress %s', figureName);
    title(titleText);
    xlabel('Z-coordinate [m]')
    ylabel('shear [N/mm^2]')
    legend('Location', 'best')
    filename_figure = [output_directory strrep(sprintf('%s %i', titleText, loadCase),'.',',')];
    saveas(gcf,filename_figure,'png');
    saveas(gcf,filename_figure,'eps');
    saveas(gcf,filename_figure,'m');
    close;
    
    cd(old_directory)
end

