function [] = plotAndSave( X, Y, titleText, x_axisLabel, y_axisLabel, figureNr, loadCase, folder)
 
    if figureNr <= 0
       figure; 
    else
       figure(figureNr);
       hold on;
    end

    plot(X,Y)
    title(titleText);
    xlabel(x_axisLabel)
    ylabel(y_axisLabel)
    
    %% Save
    
    filename = strrep(sprintf('%s%d - %s ', folder, loadCase, titleText), '.', ',');
    
    saveas(gcf, filename, 'png');
    saveas(gcf, filename ,'epsc');
    saveas(gcf, filename ,'m');
    
    %Save current figure to tikz-picture.
    %matlab2tikz(strcat(filename, 'tex'));
    
    
    hold off;
end

