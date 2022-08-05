% ordine di terminalchange e swap

nTest = 2;
optSol = -1;

load(['soluzioneCostruttivo' num2str(nTest) '.mat'])
% contiene la definizione del problema (n veicoli, punti, pesi, capacita' dei veicoli)
% rispettivamente, nVehicles, startingPoint e points, weights, capacity
% e una soluzione valida al problema idRoutes
% può contenere una soluzione ottimale

%% Parametri della Tabu Search
    
MaxIt = 100;                      % Numero massimo di iterazioni

actionKinds = [1 2 3 5 6 7];
verboseFlag = true;

[BestSol, BestCost] = tabuSearch(idRoutes, startingPoint, points, ...
                         vehiclesCapacity, nVehicles, weights, MaxIt, ...
                         actionKinds, verboseFlag);

%% Resultati e Plot

% plot della soluzione trovata
figure;
hold on
startingIndex = 1;
for i = 1:nVehicles
    currColor = [i/nVehicles 0 (nVehicles-i)/nVehicles];
    currRoute = [startingPoint; 
                 points(BestSol.Position(startingIndex:BestSol.LastPoints(i)),:); 
                 startingPoint];
    startingIndex = BestSol.LastPoints(i)+1;
    plot(currRoute(:,1), currRoute(:,2), "Color", currColor, "LineStyle", "--");
end
hold off
disp(['Total cost: ' num2str(BestSol.Cost)]);


% plot della soluzione ottima, se disponibile
if iscell(optSol)
    disp(['Optimal cost: ' num2str(optCost)]);
    disp(['Optimality gap: ' num2str((BestSol.Cost-optCost)/optCost*100) '%']);
    
    figure;
    hold on
    for i = 1:nVehicles
        currColor = [i/nVehicles 0 (nVehicles-i)/nVehicles];
        currRoute = [startingPoint; 
                     points(optSol{i},:); 
                     startingPoint];
        plot(currRoute(:,1), currRoute(:,2), "Color", currColor, "LineStyle", "--");
    end
    hold off
end


% plot dei costi
figure;
hold on
plot(BestCost, 'LineWidth', 2);
if iscell(optSol)
    plot(optCost*ones(MaxIt,1), 'LineWidth', 2, 'LineStyle','--', 'Color','r');
end
xlabel('Iteration');
ylabel('Best Cost');
grid on;
hold off