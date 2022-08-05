function idRoutes = greedy(startingPoint, points, capacity, nVehicles, weights, verboseFlag)
    % Questa funzione usa k-means in modo da creare una partizione dei
    % punti da visitare. Se la partizione identificata non rispetta i
    % vincoli di capacità, verrano scambiati punti tra un cluster e
    % l'altro. Se comunque ciò non risultasse sufficiente, verrà fatto un
    % tentativo greedy per creare una partizione valida. Infine, su ogni
    % insieme della partione ottenuta verrà risolto un problema TSP.

    % Check validita' degli input
    checkValidInput(startingPoint, points, capacity, nVehicles, weights, verboseFlag)
        
    nPoints = length(points(:,1));    
    % Utilizziamo una euristica greedy per vedere se 
    % viene individuata o meno una soluzione
    temp = weights;
    c = capacity*ones(nVehicles,1);
    indexCP = cell(nVehicles,1);
    for j = 1:nPoints
        [m,iMax] = max(temp);
        temp(iMax) = 0;
        for ic = 1:nVehicles+1
            % inseriamo prima i punti più pesanti, nel primo
            % cluster con abbastanza spazio disponibile
            if ic == (nVehicles+1)
                error('Error: no proper solution is identified')
            end
            if c(ic) >= m
                indexCP{ic} = [indexCP{ic}; iMax];
                c(ic) = c(ic) - m;
                break
            end
        end
    end       

    clusteredPoints = cell(nVehicles,1);
    for i = 1:nVehicles
        clusteredPoints(i) = {points(indexCP{i}, :)};
    end
    if verboseFlag
        % punti del cluster
        disp('Cluster points: ')
        for i = 1:nVehicles
            disp(clusteredPoints{i}')
        end
        disp('Points indexes: ')
        for i = 1:nVehicles
            disp(indexCP{i}')
        end
    end

    % sezione route second
    TSPs = cell(nVehicles,4);
    for i = 1:nVehicles
        [sol, minDist, exitflag, output] = TSPsolver(...
            generateDistMatrix([startingPoint; clusteredPoints{i}]));
        TSPs{i,1} = sol;
        TSPs{i,2} = minDist;
        TSPs{i,3} = exitflag;
        TSPs{i,4} = output;
    end
    

    % estraggo gli indici in ordine di visita:
    idRoutes = cell(nVehicles,1);
    for i = 1:nVehicles
        steps = length(clusteredPoints{i}(:, 1));
        idOrder = zeros(steps + 2, 1);
        temp = TSPs{i}.antiSubTourVar;
        for j = 1:steps
            [~, iMin] = min(temp);
            temp(iMin) = Inf;
            idOrder(j+1) = indexCP{i}(iMin);
        end
        idRoutes{i} = idOrder;
    end
end