function [BestSol, BestCost] = tabuSearch(idRoutes, startingPoint, points, ...
    vehiclesCapacity, nVehicles, weights, MaxIt, actionKinds, verboseFlag)

    %% Verifiche di compatibilità degli input %%

    checkValidParameters(MaxIt, actionKinds, verboseFlag);
    checkValidInput(startingPoint, points, vehiclesCapacity, nVehicles, weights, verboseFlag);
    n = length(points(:,1));
    checkValidSolution(idRoutes, nVehicles, n, vehiclesCapacity, weights, verboseFlag);
    
    %% Setup %%

    % elaborazione di idRoutes, rimozione degli zeri, e annotazione della
    % fine di ogni route
    lastPoints = zeros(nVehicles,1);
    routes = zeros(n,1);
    old = 0;
    for i = 1 : nVehicles
        lastPoints(i) = old + length(idRoutes{i}) - 2;
        routes((old + 1):lastPoints(i)) = idRoutes{i}(2:(end-1));
        old = lastPoints(i);
    end
    
    costFunction = @(tour, endPoints) tourLength(tour, endPoints, points, startingPoint);
    disp(['Iteration 0: Best Cost = ' num2str(costFunction(routes,lastPoints))]);
    
    % Azioni
    if verboseFlag
        disp('Adding actions:');
    end
    actionList = createActionList(n, nVehicles, actionKinds, verboseFlag);
    nAction = numel(actionList);     

    TL = round(0.5*nAction);      % Tabu Length

    %% Initialization
    
    % Create Empty Individual Structure
    empty_individual.Position = [];
    empty_individual.LastPoints = [];
    empty_individual.Cost = [];
    
    % Create Initial Solution
    sol = empty_individual;
    sol.Position = routes;
    sol.LastPoints = lastPoints;
    sol.Cost = costFunction(sol.Position, sol.LastPoints);
    
    % Initialize Best Solution Ever Found
    BestSol = sol;
    
    % Array to Hold Best Costs
    BestCost = zeros(MaxIt, 1);
    
    % Initialize Action Tabu Counters
    TC = zeros(nAction, 1);
    
    
    %% Tabu Search Main Loop
    if verboseFlag
        disp('Starting tabu search:')
        tic
    end
    for it = 1:MaxIt
        
        bestnewsol.Cost = inf;
        
        % Test azioni
        for i = 1:nAction
            if TC(i) == 0
                [newsol.Position, newsol.LastPoints] = doAction(sol.Position, sol.LastPoints, weights, vehiclesCapacity, actionList{i});
                newsol.Cost = costFunction(newsol.Position, newsol.LastPoints);
                newsol.ActionIndex = i;
                
                % debug
%                 oldLast = 0;
%                 for j = 1:nVehicles
%                     curr = newsol.Position((oldLast+1):newsol.LastPoints(j));
%                     s = sum(weights(curr));
%                     oldLast = newsol.LastPoints(j);
%                     if s > vehiclesCapacity
%                         s;
%                     end
%                 end

                if newsol.Cost <= bestnewsol.Cost
                    bestnewsol = newsol;
                end
            end
        end
        
        % aggiornamento soluzione corrente
        sol = bestnewsol;
        
        % aggiornamento della Tabu List
        for i = 1:nAction
            if i == bestnewsol.ActionIndex
                TC(i) = TL;               % aggiungimento alla Tabu List
            else
                TC(i) = max(TC(i)-1, 0);   % riducione Tabu Counter
            end
        end
        
        % aggiornamento soluzione migliore
        if sol.Cost <= BestSol.Cost
            BestSol = sol;
        end
        
        % aggiornamento miglior costo trovato
        BestCost(it) = BestSol.Cost;
        
        disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);        
    end
    if verboseFlag
        disp('Tabu search ended');
        disp(['Total time:  ' num2str(toc)]);
        disp(['Average time per iteration:  ' num2str(toc/MaxIt)]);
    end
    BestCost = BestCost(1:it);
end
