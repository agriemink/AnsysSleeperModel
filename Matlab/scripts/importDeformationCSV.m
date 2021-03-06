function [ Node, LocX, LocY, LocZ, UXm, UYm, UZm] = importDeformationCSV( filename )
% Auto-generated by MATLAB on 2019/05/02 13:31:46

%% Initialize variables.
delimiter = ';';

startRow = 2;
endRow = inf;


%% Format string for each line of text:
%   column1: double (%f)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
%	column6: double (%f)
%   column7: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%f%f%f%f%f%[^\n\r]';

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
    dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
    for block=2:length(startRow)
        frewind(fileID);
        dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
        for col=1:length(dataArray)
            dataArray{col} = [dataArray{col};dataArrayBlock{col}];
        end
    end

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
    LocY = dataArray{:, 3};
    LocZ = dataArray{:, 4};
    UXm = dataArray{:, 5};
    UYm = dataArray{:, 6};
    UZm = dataArray{:, 7};
end
  

    %% Clear temporary variables
    clearvars filename delimiter startRow formatSpec fileID dataArray ans;

end

