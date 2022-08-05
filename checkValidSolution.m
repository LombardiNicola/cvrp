function [] = checkValidSolution (idRoutes, nVehicles, nPoints, vehiclesCapacity, weights, verboseFlag)
    if sum(size(idRoutes) ~= [nVehicles,1])
        error('Error: "idRoutes" must be a cell array of length nVehicles')
    end
    % devono essere presenti tutti i punti, esattamente una volta (tranne startingPoint)
    % poteva essere scritto in maniere più chiare, ma tramite il ciclo è
    % possibile riportare immediatamente eventuali errori
    found = zeros(nPoints,1);
    count = 0;
    for i=1:nVehicles
        curr = idRoutes{i};
        cLen = length(curr);
        if sum(size(curr) ~= [cLen 1])
            error('Error: routes must be a column vector')
        end
        if sum(curr([1 cLen]) ~= [0 0])
            error('Error: the first and last index of a route must be "0"')
        end
        curr = curr(2:(cLen-1));
        if ~isnumeric(curr) || sum(~floor(curr) == curr)
            error('Error: input "idRoutes" must contain array(s) of integers')
        end
        if max(curr) > nPoints || min(curr) <= 0
            error('Error: input "idRoutes" must contain valid indexes')
        end
        found(curr) = 1;
        if sum(found) ~= count+(cLen-2)
            error('Error: indexes must be unique')
        end
        count = count + (cLen-2);
        
        % devono essere rispettati i vincoli di capacità
        if sum(weights(curr)) > vehiclesCapacity
            error('Error: solution must respect the capacity contraint')
        end
    end

    if count ~= nPoints
        error('Error: all points must be visited')
    end

    if verboseFlag
        disp('The initial solution is valid');
    end
end