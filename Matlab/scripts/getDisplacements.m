function [ nodalDisplacements ] = getDisplacements ( filename, x_coordinate, y_coordinate )
        epsilon = 0.001;

        [Node, LocX, LocY, LocZ, UXm, UYm, UZm] = importDeformationCSV(filename);
        data = struct('node', num2cell(Node), 'X', num2cell(LocX), 'Y', num2cell(LocY), 'Z', num2cell(LocZ), 'Ux', num2cell(UXm), 'Uy', num2cell(UYm),'Uz', num2cell(UZm));

        %Filter data:
        nodalDisplacements = data(abs([data.X] - x_coordinate) <= epsilon & abs([data.Y] - y_coordinate) <= epsilon, :); 
        
        %sort by z-coordinate
        [~,idx] = sort([nodalDisplacements.Z]);
        nodalDisplacements = nodalDisplacements(idx);
end
