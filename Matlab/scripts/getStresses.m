function [ nodalStresses ] = getStresses ( filename_deformations, filename_stresses , x_coordinate, y_coordinate )
        epsilon = 0.001;
        
        [Node_def, LocX, LocY, LocZ, UXm, UYm, UZm] = importDeformationCSV(filename_deformations);
        [Node_stress, S1Nm2, S2Nm2, S3Nm2, SEQVNm2, XYNm2, YZNm2, XZNm2, EQVtotalstrain, EQVelasticstrain ] = importStressesCSV(filename_stresses);
        
        data = struct('node', num2cell(Node_def), 'node2', num2cell(Node_stress), 'X', num2cell(LocX), 'Y', num2cell(LocY), 'Z', num2cell(LocZ), 'Ux', num2cell(UXm), 'Uy', num2cell(UYm),'Uz', num2cell(UZm),...
            'S1', num2cell(S1Nm2), 'S2', num2cell(S2Nm2), 'S3', num2cell(S3Nm2), 'XY', num2cell(XYNm2), 'YZ', num2cell(YZNm2), 'XZ', num2cell(XZNm2), 'EquivalentStress', num2cell(SEQVNm2),...
			'EquivalentStrain', num2cell(EQVtotalstrain), 'EquivalentElasticStrain', num2cell(EQVelasticstrain));

        %Filter data:
        if ~isempty(x_coordinate) && ~isempty(y_coordinate)
            nodalStresses = data(abs([data.X] - x_coordinate) <= epsilon & abs([data.Y] - y_coordinate) <= epsilon, :); 
        elseif ~isempty(x_coordinate)
            disp 'Alleen x-coordinaat gevuld';
            nodalStresses = data(abs([data.X] - x_coordinate) <= epsilon, :); 
        elseif ~isempty(y_coordinate) 
            nodalStresses = data(abs([data.Y] - y_coordinate) <= epsilon, :); 
        else 
            nodalStresses = data;
        end
        %sort by z-coordinate
        [~,idx] = sort([nodalStresses.Z]);
        nodalStresses = nodalStresses(idx);
end
