function [] = checkValidInput(startingPoint, points, vehiclesCapacity, nVehicles, weights, verboseFlag)
    if ~isnumeric(nVehicles) || sum(size(nVehicles) ~= [1 1])
        error('Error: input "nVehicles" must be a number')
    end
    if ~isnumeric(points)
        error('Error: input "points" must be numeric')
    end
    if ~isnumeric(startingPoint)
        error('Error: input "startingPoint" must be numeric')
    end
    
    n = length(points(:,1));
    s = length(startingPoint);
    
    % compatibilità delle dimensione dei punti e dei pesi
    if sum(size(startingPoint) ~= [1,s])
        error('Error: starting point must be a row vector')
    end
    if length(points(1,:)) ~= s
        error('Error: startingPoints and points must have the same dimension')
    end
    if length(weights) ~= n
        error('Error: there must be as many points as weights') 
    end
    if sum(size(weights) ~= [n,1])
        error('Error: weights must be a column vector')
    end

    if ~isnumeric(vehiclesCapacity) || sum(size(vehiclesCapacity) ~= [1 1])
        error('Error: input "vehicleCapacity" must be a number')
    end

    % feasability
    if vehiclesCapacity*nVehicles < sum(weights)
        error('Error: available capacity must be greater than the sum of weights')
    end

    if verboseFlag
        disp('All inputs are valid');
    end
end