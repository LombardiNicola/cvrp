rng(42);
nTest = 2;            % indica il problema test da risolvere
optSol = -1;          % non e' detto sia nota la soluzione ottimale
load(['test' num2str(nTest) '.mat'])

% approccio cluster-first route-second
idRoutes = kmeansCFRS(startingPoint, points, vehiclesCapacity, nVehicles, weights, true);

% plots
figure;
hold on
for i = 1:nVehicles
    currColor = [i/nVehicles 0 (nVehicles-i)/nVehicles];
    currRoute = [startingPoint; points(idRoutes{i}(2:(end-1)),:); startingPoint];
    nEdge = length(currRoute(:,1)) - 1;
    plot(currRoute(:,1), currRoute(:,2), 'Color', currColor, 'LineStyle', '--');
end
hold off

if iscell(optSol)
    figure;
    hold on
    for i = 1:nVehicles
        currColor = [i/nVehicles 0 (nVehicles-i)/nVehicles];
        currRoute = [startingPoint; points(optSol{i},:); startingPoint];
        nEdge = length(currRoute(:,1)) - 1;
        plot(currRoute(:,1), currRoute(:,2), 'Color', currColor, 'LineStyle', '--');
    end
    hold off
end

save(['soluzioneCostruttivo' num2str(nTest) '.mat'], 'startingPoint', 'points', 'weights', 'nVehicles', ...
    'vehiclesCapacity', 'idRoutes', 'optSol', 'optCost');