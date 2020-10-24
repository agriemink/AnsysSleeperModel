function [ funderingNodes ] = getFoundationDisplacement ( filename, x_coordinate )
        epsilon = 0.001;

        [Node, LocX, LocY, LocZ, UXm, UYm, UZm] = importDeformationCSV(filename);
        data = struct('node', num2cell(Node), 'X', num2cell(LocX), 'Y', num2cell(LocY), 'Z', num2cell(LocZ), 'Ux', num2cell(UXm), 'Uy', num2cell(UYm),'Uz', num2cell(UZm));

        %Filter data:
        funderingNodes = data(abs([data.X] - x_coordinate) <= epsilon, :); 
        
        %sort by z-coordinate
        [~,idx] = sort([funderingNodes.Z]);
        funderingNodes = funderingNodes(idx);
end
