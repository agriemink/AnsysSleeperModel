function [] = PP_FoundationDisplacements(dataFolder, analysis_fileNames, outputFolder, LoadCase)

%
%Result-array: 1 = minimale waarde (onder belasting)
%              2 = maximale waarde (midden van ligger)    
%              3 = integraal onder de grafiek. Dit zou constant moeten zijn.  


%% 
if ~isempty(analysis_fileNames)
    figure;
    hold all;
    
    for analysis_nr = 1:length(analysis_fileNames)
        analysis_fileName = analysis_fileNames{analysis_nr};
        
        filename_fundering = sprintf(dataFolder, analysis_fileName, analysis_fileName);
        foundationNodes = getFoundationDisplacement(filename_fundering, 0);

        plot([foundationNodes.Z],[foundationNodes.Uy]*1000, 'DisplayName', analysis_fileName);
     end


    titleText = ['Foundation deformation at X=0 LoadCase ' LoadCase];
    title(titleText);
    xlabel('Z-coordinate [m]')
    ylabel('deformation [mm]')
    legend;
    saveas(gcf,sprintf('%s%s %s', outputFolder, titleText, LoadCase),'png');
    saveas(gcf,sprintf('%s%s %s', outputFolder, titleText, LoadCase),'eps');
    saveas(gcf,sprintf('%s%s %s', outputFolder, titleText, LoadCase),'m');

    close all
end


end

