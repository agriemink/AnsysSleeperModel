function [ gaugeWidening] = importGaugeDeformationCSV( filename )

%% Initialize variables.
delimiter = ';';

startRow = 2;

%% Format string for each line of text:
%   column1: double (%f)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
%	column6: double (%f)
%   column7: double (%f)
%	column8: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%f%f%f%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

if fileID == -1
   disp('file not found:'); 
   disp(filename);
   Node = [];
   LocX = [];
   LocY = [];
   LocZ = [];
   UXm = [];
   UYm = [];
   UZm = [];
else

    %% Read columns of data according to format string.
    % This call is based on the structure of the file used to generate this
    % code. If an error occurs for a different file, try regenerating the code
    % from the Import Tool.
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);

    %% Close the text file.
    fclose(fileID);

    %% Post processing for unimportable data.
    % No unimportable data rules were applied during the import, so no post
    % processing code is included. To generate code which works for
    % unimportable data, select unimportable cells in a file and regenerate the
    % script.

    %% Allocate imported array to column variable names
    Node = dataArray{:, 1};
    LocX = dataArray{:, 2};
    UXmLeft = dataArray{:, 3};
    UYmLeft = dataArray{:, 4};
    UZmLeft = dataArray{:, 5};
    UXmRight = dataArray{:, 6};
    UYmRight = dataArray{:, 7};
    UZmRight = dataArray{:, 8};
    
    LocXUnique = unique(LocX);
    data = struct('node', num2cell(Node), 'X', num2cell(LocX), 'Ux_l', num2cell(UXmLeft), 'Uy_l', num2cell(UYmLeft),  'Uz_l', num2cell(UZmLeft), 'Ux_r', num2cell(UXmRight), 'Uy_r', num2cell(UYmRight),  'Uz_r', num2cell(UZmRight));
    
    result = [];
    gaugeWidening = struct;
    for n = 1:length(LocXUnique)
        x = LocXUnique(n);
        
        if (isnan(x) == 0)
            nodes = data(LocX == x, :)
        
            gaugeChange = sum([nodes.Uz_l])-sum([nodes.Uz_r]);
            result(n,:) = [x, sum([nodes.Uz_l]), sum([nodes.Uz_r]), gaugeChange ]
        end
    end
    
    gaugeWidening = struct('X', {result(:,1)}, 'gaugeChange_L', {result(:,2)}, 'gaugeChange_R', {result(:,3)}, 'gaugeChange', {result(:,4)} );
    
    

    %% Clear temporary variables
    clearvars filename delimiter startRow formatSpec fileID dataArray ans

end

