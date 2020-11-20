function [] = PostProcess_SleeperDisplacements(analysisFolder, analysis_fileNames, output_directory, figureName, LoadCases, X_coord, Y_coord)

%
%Result-array: 1 = minimale waarde (onder belasting)
%              2 = maximale waarde (midden van ligger)    

% xlswrite

Excel_filename = ['sleeperDisplacements_' figureName '.xlsx'];

for index = 1:length(LoadCases)
    loadCase = LoadCases(index)
   
    tab = strcat('Load case ', num2str(loadCase));
    
    figure;
    set(gcf,'Position',[100 100 700 500]) %Adjust figure size
    hold all; 
    %% 
    for analysis_nr = 1:length(analysis_fileNames)
        analysis_fileName = analysis_fileNames{analysis_nr};
        filename = GetAnalysisdata(analysisFolder, analysis_fileNames{analysis_nr}, loadCase, 'Kunststof_');

        foundationNodes = getDisplacements(filename, X_coord, Y_coord);
        % Part below does not work as the foundation file only
        % contains nodes at bottom level.
        % foundationNodes = foundationNodes(abs([foundationNodes.Y] - Y_coord) <= 0.0001, :)
        %Y_coord = -0.15;

        if loadCase == 1  
           gravitiy_deformation(analysis_nr) = struct('YdefGravity', [foundationNodes.Uy]*1000); 
           plot([foundationNodes.Z], [foundationNodes.Uy]*1000, 'DisplayName', strrep(['' analysis_fileName], '_', ' '));
           Excel_data = [foundationNodes.Uy]*1000;
        else
            plot([foundationNodes.Z], [foundationNodes.Uy]*1000 - [gravitiy_deformation(analysis_nr).YdefGravity], 'DisplayName', strrep(['' analysis_fileName], '_', ' '));
            Excel_data = [foundationNodes.Uy]*1000 - [gravitiy_deformation(analysis_nr).YdefGravity];
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
    titleText = sprintf('Sleeper deformations %s at X=%g Y =%g ', figureName, X_coord, Y_coord);
    title(titleText);
    xlabel('Z-coordinate [m]')
    ylabel('displacement [mm]')
    legend('Location', 'best')
    filename = [output_directory strrep(sprintf('%s %i', titleText, loadCase),'.',',')];
    saveas(gcf,filename,'png');
    saveas(gcf,filename,'eps');
    saveas(gcf,filename,'m');
    close;
    
    cd(old_directory)
end

