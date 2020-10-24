function [] = PP_reinforcementElementsConvergence(analysis_files_simple, analysis_files_standard, output_directory, loadCaseNumber)
    close all;
    %
    %Result-array: 1 = minimale waarde (onder belasting)
    %              2 = maximale waarde (midden van ligger)    
    %              3 = integraal onder de grafiek. Dit zou constant moeten zijn.  
    result_simple = zeros(size(analysis_files_simple,1),4);
    result = zeros(size(analysis_files_standard,1),4);
    
    %%
    for analysis_nr = 1:size(analysis_files_simple,1)

        filename_fundering = analysis_files_simple{analysis_nr}; %strcat(folder_simple{analysis_nr}, analysis_simple{analysis_nr}, '_Foundationdeformations_', num2str(loadCase) ,'_Deformations.csv');
        [Node, LocX, LocY, LocZ, UXm, UYm, UZm] = importDeformationCSV(filename_fundering);

        data = [(1:size(Node,1))', Node, LocX, LocY, LocZ, UXm, UYm, UZm];
%         filter = LocY == min(LocY); %y = -0.15 adn x = 0
        filter = abs(LocX) <= 0.0000001 & LocY == min(LocY); %y = -0.15 adn x = 0

        filteredData = data(filter ~= 0, :);   
        if size(filteredData,1) > 0
            [~,idx] = sort(filteredData(:,5)); % sort just the on Z-location
            graphData_simple = filteredData(idx,:);
            result_simple(analysis_nr ,:) = vpa([min(graphData_simple(:,7)), max(graphData_simple(:,7)), trapz(graphData_simple(:,5), graphData_simple(:,7)), size(graphData_simple,1)],8);
        elseif size(data,1) > 0
            graphData_simple = data;
        else
            graphData_simple = zeros(7);
        end

        figure(1)
        hold all
        plot(graphData_simple(:,5),graphData_simple(:,7), 'DisplayName', strrep(analysis_files_simple{analysis_nr,2}, '_HDPE_Simple_', ' '));
        titleText = 'Foundation deformation at X=0 Simple reinforcement model';
        title(titleText);
        xlabel('Z-coordinate [m]')
        ylabel('deformation [m]')
    end
    hold off
    legend show
    filename = strcat(output_directory, loadCaseNumber, '-', strrep(titleText, ' ', '_'));
    saveas(gcf, filename,'png');
    saveas(gcf, filename,'eps');
	saveas(gcf, filename,'m');
    %matlab2tikz(strcat(filename, 'tex'));
    
     for analysis_nr = 1:size(analysis_files_standard,1)

        filename_fundering = analysis_files_standard{analysis_nr}; %, '_Foundationdeformations_', num2str(loadCase) ,'_Deformations.csv');
        [Node, LocX, LocY, LocZ, UXm, UYm, UZm] = importDeformationCSV(filename_fundering);

        data = [(1:size(Node,1))', Node, LocX, LocY, LocZ, UXm, UYm, UZm];
%       filter = LocY == min(LocY); %y = -0.15 adn x = 0
        filter = abs(LocX) <= 0.0000001 & LocY == min(LocY); %y = -0.15 adn x = 0

        filteredData = data(filter ~= 0, :);
        if size(filteredData,1) > 0
            [~,idx] = sort(filteredData(:,5)); % sort just the on Z-location
            graphData = filteredData(idx,:);
            result(analysis_nr,:) = vpa([min(graphData(:,7)), max(graphData(:,7)), trapz(graphData(:,5), graphData(:,7)), size(graphData,1)],8);
        elseif size(data,1) > 0
            graphData = data;
        else
            graphData = zeros(1,7);
            graphData(:,5) = 1;
        end
        
        figure(2)
        hold all
        plot(graphData(:,5),graphData(:,7), 'DisplayName', strrep(analysis_files_standard{analysis_nr,2}, '_HDPE_', ' '));
        titleText = 'Foundation deformation at X=0 circular reinforcement model';
        title(titleText);
        xlabel('Z-coordinate [m]')
        ylabel('deformation [m]')
     end     
    hold off
    legend show
    filename = strcat(output_directory, loadCaseNumber, '-', strrep(titleText, ' ', '_'));
    saveas(gcf, filename,'png');
    saveas(gcf, filename,'eps');
	saveas(gcf, filename,'m');
    %matlab2tikz(strcat(filename, 'tex'));
     
     %% Filter results
     filter = result_simple(:,1) ~= 0;
     result_simple = result_simple(filter ~= 0, :);
     
     filter = result(:,1) ~= 0;
     result = result(filter ~= 0, :);
     %%
     
     
    figure(3)
    hold on
    plot(result_simple(:, 4), result_simple(:, 2),'.b-')
    plot(result(:, 4), result(:, 2),'.r-')
    titleText = 'Maximum deformation of bottom nodes for increasing reinforcement elements';
    title(titleText);
    xlabel('Numer of nodes')
    ylabel('Maximum deformation [m]')
    legend('Simple reinforcement model', 'Circular reinforcement model')   
    filename = strcat(output_directory, loadCaseNumber, '-', strrep(titleText, ' ', '_'));
    saveas(gcf, filename,'png');
    saveas(gcf, filename,'eps');
	saveas(gcf, filename,'m');
    %matlab2tikz(strcat(filename, 'tex'));
    
    figure(4)
    hold on
    plot(result_simple(:, 4), result_simple(:, 1),'.b-')
    plot(result(:, 4), result(:, 1),'.r-')
    titleText = 'Minimum deformation of bottom nodes for increasing reinforcement elements';
    title(titleText);
    xlabel('Number of nodes')
    ylabel('Minimum deformation [m]')
    legend('Simple reinforcement model', 'Circular reinforcement model')   
    saveas(gcf, filename,'png');
    saveas(gcf, filename,'eps');
	saveas(gcf, filename,'m');
    %matlab2tikz(strcat(filename, 'tex'));

    figure(5)
    if max(result_simple(:, 4)) > max(result(:, 4))
        %Get the simple result value.
        Maximum = result_simple(end, 2);
    else
        %Get the standard result value.
        Maximum = result(end, 2);
    end
    hold on
    plot(result_simple(:, 4), 1 - (result_simple(:, 2)/Maximum),'.b-')
    plot(result(:, 4), 1 - (result(:, 2)/Maximum),'.r-')
    titleText = 'Normalised maximum deformation of bottom nodes for increasing reinforcement elements';
    title(titleText);
    xlabel('Numer of nodes')
    ylabel('Normalised maximum deformation [m]')
    legend('Simple reinforcement model', 'Circular reinforcement model')   
    saveas(gcf, filename,'png');
    saveas(gcf, filename,'eps');
	saveas(gcf, filename,'m');
    %matlab2tikz(strcat(filename, 'tex'));

    figure(6)
    if max(result_simple(:, 4)) > max(result(:, 4))
        %Get the simple result value.
        Minimum = result_simple(end, 1);
    else
        %Get the standard result value.
        Minimum = result(end, 1);
    end
    
    hold on
    plot(result_simple(:, 4), 1 - (result_simple(:, 1)/Minimum),'.b-')
    plot(result(:, 4), 1 - (result(:, 1)/Minimum),'.r-')
    titleText = 'Normalised minimum deformation of bottom nodes for increasing reinforcement elements';
    title(titleText);
    xlabel('Number of nodes')
    ylabel('Normalised minimal deformation [-]')
    legend('Simple reinforcement model', 'Circular reinforcement model')   
    saveas(gcf, filename,'png');
    saveas(gcf, filename,'eps');
	saveas(gcf, filename,'m');
    %matlab2tikz(strcat(filename, 'tex'));
end

