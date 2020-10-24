clear
close all
addpath('./matlab2tikz');
oldFolder = cd('F:\OneDrive\Documenten\Tu\Afstuderen\PostProcess\MatlabPostProcess\Results\20201015_static_AnalysisLojda -16-Oct-2020');



%% Displacement data Munchen:

%201_deformation_data_225kN = []




%% Displacement data Luuk:


%%
% 1 - vertical deformation of foundation 202 Beton 2Div, 
load_cases = [1 2 3 4 5 6 7]; 
%load_cases = [1]; 

%"201 PE Multiple Static, ",...
%"202 HDPE Multiple Static, ",...
%All names needs to be the exact figure name (this + general_part)
filenames_all = [ ... 
    "201 PE 2DIV, ",...
    "201 PE Simple 2DIV, ",...
    "202 HDPE 2DIV, ",...
    "202 HDPE Simple 2DIV, ",...
    "202 Hout 2Div, ",...
    "202 Beton 2Div, ",...
    ];

filenames_without_other_materials = [ ...
    "201 PE 2DIV, ",...
    "201 PE Simple 2DIV, ",...
    "202 HDPE 2DIV, ",...
    "202 HDPE Simple 2DIV, ",...
    ];

filenames_without_octagonal = [ ...
    "201 PE 2DIV, ",...
    "202 HDPE 2DIV, ",...
    "202 Hout 2Div, ",...
    "202 Beton 2Div, ",...
    ];

MergePlotsVerticalDeformation(filenames_all, '', load_cases);
MergePlotsVerticalDeformation(filenames_without_other_materials, 'WithoutOctagonal', load_cases);
MergePlotsVerticalDeformation(filenames_without_octagonal, 'OnlyCircular', load_cases);




cd(oldFolder);


function [] = MergePlotsVerticalDeformation(filenames, custom_part, load_cases)
    general_part = "vertical deformation of foundation";
    filename_layout = '%d - %s %s.fig';

    test = zeros(length(filenames), 1);
    for load_case = 1:length(load_cases)

        
        
        x_label = 'Z-coordinate [m]';
        y_label = 'Vertical deformation [mm]';
        legend_options = ('Location', 'southoutside', 'Orientation','horizontal', 'AutoUpdate','on');
        MergePlots(filenames, output_filename, figureTitle, x_label, y_label, legend_options)
        
        
        for n = 1:length(filenames)

            figure_name = sprintf(filename_layout, load_case, general_part, filenames(n))
            test(n) = hgload(figure_name);
        end

        

        
        
        handleLine = findobj(test,'type','line')

        figure;
        hold all;
        for i = 1 : length(handleLine)
            legend_name =  strtrim(replace(replace(replace(filenames(i),' 2DIV,',''),' 2Div,',''),'Simple','Octagonal')); %translate simple to octagonal and remove trailing comma and 2DIV.
            figure_plot = plot(get(handleLine(i),'XData'), get(handleLine(i),'YData'), 'DisplayName', legend_name); 
            set(gcf, 'Position',  [100,100, 1080,800])
        end
        title(general_part);
        xlabel() 
        ylabel('Vertical deformation [mm]') 

        %gridLegend(figure_plot, 2, 'Location', 'bestoutside', 'Orientation','horizontal', 'AutoUpdate','on');


        filename = replace(sprintf('%s %s-load case %d.tex', general_part, custom_part, load_case),' ','_');
        %filename = replace(sprintf('%s zonder octagonaal-load case %d.tex', general_part, load_case),' ','_'); 
        %filename = replace(sprintf('%s Oct vs Cir-load case %d.tex', general_part, load_case),' ','_');
        %added code to place southoutside legend below axis label. https://tex.stackexchange.com/a/115539/224067
        matlab2tikz(filename, 'extraAxisOptions', 'xlabel style={name=xlabel}, xticklabel style={/pgf/number format/fixed}, legend style={at={(xlabel.south)},yshift=-1ex, anchor=north,legend cell align=left}');

        %saveas(gcf, filename, 'png');
        saveas(gcf, filename ,'m');

        close all;
    end
end

function [] = MergePlots(filenames, output_filename, figureTitle, x_label, y_label, legend_options)
    %filename should be a perfect match e.g. 'LoadCase5 - _gaugeWideningOverview.fig'
    
    figures_ = zeros(length(filenames), 1);
    
    for n = 1:length(filenames)
        figures_(n) = hgload(figure_name);
    end

    handleLine = findobj(test,'type','line')
    
    figure;
    hold all;
    for i = 1 : length(handleLine)
        legend_name =  strtrim(replace(replace(replace(filenames(i),' 2DIV,',''),' 2Div,',''),'Simple','Octagonal')); %translate simple to octagonal and remove trailing comma and 2DIV.
        plot(get(handleLine(i),'XData'), get(handleLine(i),'YData'), 'DisplayName', legend_name); 
        set(gcf, 'Position',  [100,100, 1080,800]) % Create larger figures.
    end
    
    title(figureTitle);
        
    xlabel(x_label) 
    ylabel(y_label) 
    
    if (legend_options == '')
        legend();
    else
        %Example: legend('Location', 'southoutside', 'Orientation','horizontal', 'AutoUpdate','on');
        legend(legend_options)
    end
    %gridLegend(figure_plot, 2, 'Location', 'bestoutside', 'Orientation','horizontal', 'AutoUpdate','on');


    filename = replace(output_filename,' ','_');
    %added code to place southoutside legend below axis label. https://tex.stackexchange.com/a/115539/224067
    matlab2tikz(filename, 'extraAxisOptions', 'xlabel style={name=xlabel}, xticklabel style={/pgf/number format/fixed}, legend style={at={(xlabel.south)},yshift=-1ex, anchor=north,legend cell align=left}');
    saveas(gcf, filename ,'m');

    close all;
end
