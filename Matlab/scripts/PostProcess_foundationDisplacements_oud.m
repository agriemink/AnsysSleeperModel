clear;clc;close all;

basefolder = 'O:\Afstuderen\Ansys\_AnsysModelWorkingDirectory\';
commonFolder = strcat(basefolder, '20190802_Static\');
analysis_simple = {'202_HDPE_Simple_1Div'; '202_HDPE_Simple'; '202_HDPE_Simple_3Div';'202_HDPE_Simple_4Div';'202_HDPE_Simple_5Div';'202_HDPE_Simple_6Div'};
analysis = {'202_HDPE_1Div'; '202_HDPE_2Div'; '202_HDPE_3Div';'202_HDPE_2Div'};

folder_simple = strcat(commonFolder, analysis_simple, '\');
folder = strcat(commonFolder, analysis, '\');

LoadCases = [4];

%
%Result-array: 1 = minimale waarde (onder belasting)
%              2 = maximale waarde (midden van ligger)    
%              3 = integraal onder de grafiek. Dit zou constant moeten zijn.  
result_simple = zeros(size(LoadCases,1),size(analysis_simple,1),3);
result = zeros(size(LoadCases,1),size(analysis,1),3);
for index = 1:size(LoadCases,1)
    loadCase = LoadCases(index);
   
    %%
    for analysis_nr = 1:size(analysis_simple,1)
        
        filename_fundering = strcat(folder_simple{analysis_nr}, analysis_simple{analysis_nr}, '_Foundationdeformations_', num2str(loadCase) ,'_Deformations.csv');
        [Node, LocX, LocY, LocZ, UXm, UYm, UZm] = importDeformationCSV(filename_fundering);
        
        data = [(1:size(Node,1))', Node, LocX, LocY, LocZ, UXm, UYm, UZm];
%         filter = LocY == min(LocY); %y = -0.15 adn x = 0
        filter = abs(LocX) <= 0.0000001 & LocY == min(LocY); %y = -0.15 adn x = 0
        
        filterdData = data(filter ~= 0, :);   
        [~,idx] = sort(filterdData(:,5)); % sort just the on Z-location
        graphData_simple = filterdData(idx,:);
       

        figure(1)
        hold on
        plot(graphData_simple(:,5),graphData_simple(:,7));
        titleText = 'Foundation deformation at X=0 Simple reinforcement model';
        title(titleText);
        xlabel('Z-coordinate [m]')
        ylabel('deformation [m]')
        saveas(gcf,sprintf('%s %d', titleText, loadCase),'png');
        saveas(gcf,sprintf('%s %d', titleText, loadCase),'eps');

        result_simple(index, analysis_nr,:) = vpa([min(graphData_simple(:,7)), max(graphData_simple(:,7)), trapz(graphData_simple(:,5), graphData_simple(:,7))],8);
    end
    
     for analysis_nr = 1:size(analysis,1)
        
        filename_fundering = strcat(folder{analysis_nr}, analysis{analysis_nr}, '_Foundationdeformations_', num2str(loadCase) ,'_Deformations.csv');
        [Node, LocX, LocY, LocZ, UXm, UYm, UZm] = importDeformationCSV(filename_fundering);
        
        data = [(1:size(Node,1))', Node, LocX, LocY, LocZ, UXm, UYm, UZm];
%         filter = LocY == min(LocY); %y = -0.15 adn x = 0
        filter = abs(LocX) <= 0.0000001 & LocY == min(LocY); %y = -0.15 adn x = 0
        
        filterdData = data(filter ~= 0, :);   
        [~,idx] = sort(filterdData(:,5)); % sort just the on Z-location
        graphData = filterdData(idx,:);
       
        figure(2)
        hold on
        plot(graphData(:,5),graphData(:,7));
        titleText = 'Foundation deformation at X=0 circular reinforcement model';
        title(titleText);
        xlabel('Z-coordinate [m]')
        ylabel('deformation [m]')
        saveas(gcf,sprintf('%s %d', titleText, loadCase),'png');
        saveas(gcf,sprintf('%s %d', titleText, loadCase),'eps');
        result(index, analysis_nr,:) = vpa([min(graphData(:,7)), max(graphData(:,7)), trapz(graphData_simple(:,5), graphData_simple(:,7))],8);
     end 
    
    figure(3)
    hold on
    plot(1:size(analysis_simple,1), result_simple(index, :, 2))
    plot(1:size(analysis,1), result(index, :, 2),'r')
    titleText = 'Maximum deformation';
    title(titleText);
    xlabel('Numer of divisions')
    ylabel('Maximum deformation [m]')
    saveas(gcf,sprintf('%s %d', titleText, loadCase),'png');
    saveas(gcf,sprintf('%s %d', titleText, loadCase),'eps');
    
    figure(4)
    hold on
    plot(1:size(analysis_simple,1), result_simple(index, :, 1))
    plot(1:size(analysis,1), result(index, :, 1),'r')
    titleText = 'Minimum deformation';
    title(titleText);
    xlabel('Number of divisions')
    ylabel('Minimum deformation [m]')
    saveas(gcf,sprintf('%s %d', titleText, loadCase),'png');
    saveas(gcf,sprintf('%s %d', titleText, loadCase),'eps');
end

