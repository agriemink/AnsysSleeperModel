function [Node,S1Nm2,S2Nm2,S3Nm2,SEQVNm2,XYNm2,YZNm2, XZNm2, EQVtotalstrain,EQVelasticstrain] = importStressesCSV( filename )
    % New version with shear stresses

    %% Import data from text file.
    % Script for importing data from the following text file:
    %
    %    O:\Afstuderen\Ansys\_AnsysModelWorkingDirectory\20190411_HDPE_static\202_HDPE_reinforced\202_HDPE_reinforced_RailfootRotation_R_4.csv
    %
    % To extend the code to different selected data or a different text file,
    % generate a function instead of a script.

    % Last changed on 12-11-2020

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
    %   column9: double (%f)
    %	column10: double (%f)
    % For more information, see the TEXTSCAN documentation.
    formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

    %% Open the text file.
    fileID = fopen(filename,'r');

    if fileID == -1
        disp(filename);
        Node = [];
        S1Nm2 = [];
        S2Nm2 = [];
        S3Nm2 = [];
        SEQVNm2 = [];
        XYNm2 = [];
        YZNm2 = [];
        XZNm2 = [];
        EQVtotalstrain = [];
        EQVelasticstrain = [];
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
    S1Nm2 = dataArray{:, 2};
    S2Nm2 = dataArray{:, 3};
    S3Nm2 = dataArray{:, 4};
    SEQVNm2 = dataArray{:, 5};
    XYNm2 = dataArray{:, 6};
    YZNm2 = dataArray{:, 7};
    XZNm2 = dataArray{:, 8};
    EQVtotalstrain = dataArray{:, 9};
    EQVelasticstrain = dataArray{:, 10};

    %% Clear temporary variables
    clearvars filename delimiter startRow formatSpec fileID dataArray ans;
    end
    
    
    
end

