function [] = plotAndSave( X, Y, titleText, x_axisLabel, y_axisLabel, figureNr, loadCase, folder, legendName)
 
    if figureNr <= 0
       figure; 
    else
       figure(figureNr);
       hold all;
    end

    if nargin <= 8 %No legend name
        plot(X,Y) 
    else
        plot(X,Y, 'DisplayName', legendName)
        legend;
    end
    
   
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

