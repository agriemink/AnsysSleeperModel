function [ column_letter ] = getExcelColumn( columnNumber )
% Return the column number as letter format;
% A = 1
% AA = 27
% Etc.
% max = ZZ = 676
    
    alfabet = ['ABCDEFGHIJKLMNOPQRSTUVWXYZ'];
    alfabet_size = length(alfabet);
        

    if columnNumber > length(alfabet)   
        prefix_index = floor(columnNumber/alfabet_size);
        column_letter_prefix = getExcelColumn(prefix_index);
    else 
        column_letter_prefix = '';
        prefix_index = 0;
    end
    
    remainder = columnNumber - (prefix_index*alfabet_size);
    column_letter = strcat(column_letter_prefix, alfabet(remainder));
end

