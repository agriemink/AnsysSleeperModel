function [ gaugeWidening ] = getGaugeWidening(filename)

    [ Node, LocX, LocY, LocZ, UXm, UYm, UZm] = importDeformationCSV(filename);
    data = struct('node', num2cell(Node), 'X', num2cell(LocX), 'Y', num2cell(LocY), 'Z', num2cell(LocZ), 'Ux', num2cell(UXm), 'Uy', num2cell(UYm),'Uz', num2cell(UZm));
    %data = [(1:size(Node,1))', Node, LocX, LocY, LocZ, UXm, UYm, UZm];

    %% Seperate nodes:
    nodesLeft = data(LocZ > 0, :);
    nodesRight = data(LocZ <= 0, :);

    [~,idx] = sort([nodesLeft.X]);
    nodesLeft = nodesLeft(idx);
    
    [~,idx] = sort([nodesRight.X]);
    nodesRight = nodesRight(idx);
    
    %Left = positive Z-coordinate, so a positve number will increase the gauge.
    %Right = negative Z-coordinate, here a negative number will increase
    %the gauge.
    %therefore: gauge widening = Left - Right (minus will become plus).
    gaugeWideningValue = num2cell(roundFloat([nodesLeft.Uz]-[nodesRight.Uz],6));
    gaugeWidening = struct('X', {nodesLeft.X}, 'Y', {nodesLeft.Y}, 'Z_L', {nodesLeft.Z}, 'Z_R', {nodesRight.Z}, 'gaugeChange_L', {nodesLeft.Uz}, 'gaugeChange_R', {nodesRight.Uz}, 'gaugeChange', gaugeWideningValue);

    
end

