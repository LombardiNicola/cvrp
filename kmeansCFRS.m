function idRoutes = kmeansCFRS(startingPoint, points, capacity, nVehicles, weights, verboseFlag)
    % Questa funzione usa k-means in modo da creare una partizione dei
    % punti da visitare. Se la partizione identificata non rispetta i
    % vincoli di capacità, verrano scambiati punti tra un cluster e
    % l'altro. Se comunque ciò non risultasse sufficiente, verrà fatto un
    % tentativo greedy per creare una partizione valida. Infine, su ogni
    % insieme della partione ottenuta verrà risolto un problema TSP.

    % Check validita' degli input
    checkValidInput(startingPoint, points, capacity, nVehicles, weights, verboseFlag)
    
    [IDX, ~] = kmeans(points, nVehicles);
    
    nPoints = length(points(:,1));
    indexCP = cell(nVehicles,1);
    temp = (1:nPoints)';
    for i = 1:nVehicles
        indexCP(i) = {temp(IDX==i)};
    end
    
    if verboseFlag
        % indici dei punti dei cluster
        disp('Points indexes: ');
        for i = 1:nVehicles
            disp(indexCP{i}');
        end
    end
    % limite per avere convergenza ad una soluzione ammissibile (non garantita)
    maxImprovementSteps = nPoints*2;
    residualCapacity = zeros(nVehicles, 1);
    for iStep = 1:maxImprovementSteps
        for i = 1:nVehicles
            residualCapacity(i) = capacity - sum(weights(indexCP{i}));
        end
        [m, iMin] = min(residualCapacity);
        if m > 0
            % se residualCapacity(i) > 0 per ogni i, non è necessario fare
            % scambi
            if verboseFlag
                disp('All constraints are respected');
            end
            break
        end
        [~, iMax] = max(residualCapacity);
        if verboseFlag
            disp('Some exchange is needed');
        end
        wFreeSpace = weights(indexCP{iMax});
        wTooMuch = weights(indexCP{iMin});
        
        aChangeWasDone = false;
        % quanto fuori sono i due veicoli
        bestGapSoFar = min(residualCapacity(iMin),0) + min(residualCapacity(iMax),0);
        bestChangeI = -1;
        bestChangeJ = -1;
        for i = 1:length(wTooMuch)
            % si scambia l'item corrente con uno dell'altro set, se non
            % rompe il vincolo di capacita'
            for j = 1:length(wFreeSpace)
                if residualCapacity(iMin) - wFreeSpace(j) + wTooMuch(i) >= 0
                    % se si sistema il veicolo più problematico
                    if residualCapacity(iMax) + wFreeSpace(j) - wTooMuch(i) >= 0
                        % faccio lo scambio
                        aChangeWasDone = true;
                        iTarget = indexCP{iMin}(i);
                        indexCP{iMin}(i) = indexCP{iMax}(j);
                        indexCP{iMax}(j) = iTarget;
                        break
                    end
                else
                    % se migliora il gap, lo tengo da parte
                    newGap =  min(residualCapacity(iMin) - wFreeSpace(j) + wTooMuch(i), 0) ...
                        + min(residualCapacity(iMax) + wFreeSpace(j) - wTooMuch(i), 0);
                    if newGap > bestGapSoFar
                        bestGapSoFar = newGap;
                        bestChangeI = i;
                        bestChangeJ = j;
                    end
                end
            end
            if aChangeWasDone
                break
            end
        end
        if ~aChangeWasDone && bestChangeJ == -1 
            break
        end
        if ~aChangeWasDone
            iTarget = indexCP{iMin}(bestChangeI);
            indexCP{iMin}(bestChangeI) = indexCP{iMax}(bestChangeJ);
            indexCP{iMax}(bestChangeJ) = iTarget;
        end
    end
    
    % verifica che la soluzione sia ammissibile
    if iStep == maxImprovementSteps
        for i = 1:nVehicles
            residualCapacity(i) = capacity - sum(weights(indexCP{i}));
            if residualCapacity(i) < 0
                % la soluzione trovata non è ammissibile. Utilizziamo una
                % euristica greedy per vedere se individuiamo o meno una
                % soluzione
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