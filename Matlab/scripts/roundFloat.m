function [ roundedNumbers ] = roundFloat(numbers, decimals)

    
    roundedNumbers = round(numbers .* 10^decimals) .* 10^(-decimals);

end

