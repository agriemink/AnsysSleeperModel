function [] = PostProcess_foundationDisplacements(analysisFolder, analysis_fileNames, output_directory, figureName, LoadCases, X_coord, Y_coord)

%
%Result-array: 1 = minimale waarde (onder belasting)
%              2 = maximale waarde (midden van ligger)    

for index = 1:length(LoadCases)
    loadCase = LoadCases(index)
   
    figure;
    set(gcf,'Position',[100 100 700 500])
    hold all; 
    %% 
    for analysis_nr = 1:length(analysis_fileNames)
        analysis_fileName = analysis_fileNames{analysis_nr}
        
        specificAnalysisFolder = strcat(analysisFolder, analysis_fileName);
        if exist(specificAnalysisFolder,'dir')
            filename_fundering = strcat(specificAnalysisFolder,'/',analysis_fileName, '_Foundationdeformations_', num2str(loadCase) ,'_Deformations.csv');
            foundationNodes = getFoundationDisplacement(filename_fundering, X_coord);
            % Part below does not work as the foundation file only
            % contains nodes at bottom level.
            % foundationNodes = foundationNodes(abs([foundationNodes.Y] - Y_coord) <= 0.0001, :)
            Y_coord = -0.15;
            
            if loadCase == 1  
               gravitiy_deformation(analysis_nr) = struct('YdefGravity', [foundationNodes.Uy]*1000); 
               plot([foundationNodes.Z], [foundationNodes.Uy]*1000, 'DisplayName', strrep(['' analysis_fileName], '_', ' '));
               
            else
                plot([foundationNodes.Z], [foundationNodes.Uy]*1000 - [gravitiy_deformation(analysis_nr).YdefGravity], 'DisplayName', strrep(['' analysis_fileName], '_', ' '));
            end
            
        else
           disp 'Dir not found'
           specificAnalysisFolder
        end
    end
    
    
    hold off
    titleText = sprintf('Deformations %s at X=%g Y =%g ', figureName, X_coord, Y_coord);
    title(titleText);
    xlabel('Z-coordinate [m]')
    ylabel('displacement [mm]')
    legend('Location', 'best')
    filename = [output_directory strrep(sprintf('%s %i', titleText, loadCase),'.',',')];
    saveas(gcf,filename,'png');
    saveas(gcf,filename,'eps');
    saveas(gcf,filename,'m');
    close;
end

