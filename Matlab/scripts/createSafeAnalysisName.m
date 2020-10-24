function [ structSafeName ] = createSafeAnalysisName( analysis_name )

    structSafeName = strcat('A', strrep(strrep(analysis_name, '_', '__'), '.', '_'));



end

