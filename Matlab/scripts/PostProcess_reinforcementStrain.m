function [] = PostProcess_reinforcementStrain(analysisFolder, analysis_fileNames, output_directory, figureName, LoadCases)

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
        [ filename_deformation, filename_stresses ] = GetAnalysisdata(analysisFolder, analysis_fileNames{analysis_nr}, loadCase, 'WapeningBoven');

        X_coord = '';
        Y_coord = '';
        
        foundationNodes = getStresses(filename_deformation, filename_stresses, X_coord, Y_coord);
                     
        %Get maximum strain value per z-coordinate
        z_coordinates = unique([foundationNodes.Z]);
        for z_index = 1:length(z_coordinates)
            z_coordinate = z_coordinates(z_index);
            foundationNodesForThisZ = foundationNodes(abs([foundationNodes.Z] - z_coordinate) < 0.0001, :); 
            
            strain_values(z_index) = max([foundationNodesForThisZ.EquivalentStrain]);

        end

       if loadCase == 1
           gravitiy_deformation_set = 1;
           gravitiy_deformation(analysis_nr) = struct('StrainGravity', strain_values); 
           plot(z_coordinates, strain_values, 'DisplayName', strrep(['Max strain ' analysis_fileName], '_', ' '));
           Excel_data = strain_values;
        elseif gravitiy_deformation_set == 1
           plot(z_coordinates, strain_values - [gravitiy_deformation(analysis_nr).StrainGravity], 'DisplayName', strrep(['Max strain ' analysis_fileName], '_', ' '));
           Excel_data = strain_values - [gravitiy_deformation(analysis_nr).StrainGravity];
        else
           plot(z_coordinates, strain_values, 'DisplayName', strrep(['Max strain ' analysis_fileName], '_', ' '));
           Excel_data = strain_values;
        end

        old_directory = cd(output_directory);
        xlswrite(Excel_filename, {analysis_fileName}, tab, strcat(getExcelColumn(analysis_nr+1), '1'));
        xlswrite(Excel_filename, Excel_data', tab, strcat(getExcelColumn(analysis_nr+1), '2')); % +1 because of the first z-coordinate column
        cd(old_directory)
    end
    
    old_directory = cd(output_directory);
    xlswrite(Excel_filename, {'Z-coordinate'}, tab, 'A1');
    xlswrite(Excel_filename,  [foundationNodes.Z]', tab, 'A2');

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

