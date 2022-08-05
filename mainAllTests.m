% proporzioni delle figure
set(groot, 'defaultFigureUnits', 'centimeters', 'defaultFigurePosition', [0 0 15 10]);

verboseFlag = false;
MaxIt = 100;                      % Numero massimo di iterazioni
totTest=3;
costi = zeros(7,totTest);
limit_y_axis_costi = [700 1300; 1000 2400; 1600 3000]; % devi modificarlo
for nTest = 1:totTest
    curryLimit=limit_y_axis_costi(nTest,:);
    rng(42);
    optSol = -1;          % non e' detto sia nota la soluzione ottimale
    load(['test' num2str(nTest) '.mat'])
    n = length(points(:,1));
    costFunction = @(tour, endPoints) tourLength(tour, endPoints, points, startingPoint);
    % approccio cluster-first route-second
    idRoutes = kmeansCFRS(startingPoint, points, vehiclesCapacity, nVehicles, weights, verboseFlag);
    idRoutes2 = greedy(startingPoint, points, vehiclesCapacity, nVehicles, weights, verboseFlag);
    % plots
    name = ['Soluzione costruttivo test' num2str(nTest)];
    fig = figure("Name", name);
    hold on
    for i = 1:nVehicles
        currColor = [i/nVehicles 0 (nVehicles-i)/nVehicles];
        currRoute = [startingPoint; points(idRoutes{i}(2:(end-1)),:); startingPoint];
        nEdge = length(currRoute(:,1)) - 1;
        plot(currRoute(:,1), currRoute(:,2), 'Color', currColor, 'LineStyle', '--');
        
    end
    hold off

    lastPoints = zeros(nVehicles,1);
    routes = zeros(n,1);
    old = 0;
    for i = 1 : nVehicles
        lastPoints(i) = old + length(idRoutes{i}) - 2;
        routes((old + 1):lastPoints(i)) = idRoutes{i}(2:(end-1));
        old = lastPoints(i);
    end
    costi(2,nTest) = costFunction(routes, lastPoints);

    exportgraphics(fig,[pwd '/images/soluzioneCostruttivoTest' num2str(nTest) '.png'],'Resolution',300)

    name = ['Soluzione greedy test' num2str(nTest)];
    fig = figure("Name", name);
    hold on
    for i = 1:nVehicles
        currColor = [i/nVehicles 0 (nVehicles-i)/nVehicles];
        currRoute = [startingPoint; points(idRoutes2{i}(2:(end-1)),:); startingPoint];
        nEdge = length(currRoute(:,1)) - 1;
        plot(currRoute(:,1), currRoute(:,2), 'Color', currColor, 'LineStyle', '--');
    end
    hold off
    exportgraphics(fig,[pwd '/images/soluzioneGreedyTest' num2str(nTest) '.png'],'Resolution',300)

    lastPoints = zeros(nVehicles,1);
    routes = zeros(n,1);
    old = 0;
    for i = 1 : nVehicles
        lastPoints(i) = old + length(idRoutes2{i}) - 2;
        routes((old + 1):lastPoints(i)) = idRoutes2{i}(2:(end-1));
        old = lastPoints(i);
    end
    costi(3,nTest) = costFunction(routes, lastPoints);

    name = ['Soluzione ottimale test' num2str(nTest)];
    fig = figure("Name", name);
    hold on
    for i = 1:nVehicles
        currColor = [i/nVehicles 0 (nVehicles-i)/nVehicles];
        currRoute = [startingPoint; points(optSol{i},:); startingPoint];
        nEdge = length(currRoute(:,1)) - 1;
        plot(currRoute(:,1), currRoute(:,2), 'Color', currColor, 'LineStyle', '--');
    end
    hold off
    exportgraphics(fig,[pwd '/images/soluzioneOttimaleTest' num2str(nTest) '.png'],'Resolution',300)

    lastPoints = zeros(nVehicles,1);
    routes = zeros(n,1);
    old = 0;
    for i = 1 : nVehicles
        lastPoints(i) = old + length(optSol{i});
        routes((old + 1):lastPoints(i)) = optSol{i};
        old = lastPoints(i);
    end
    costi(1,nTest) = costFunction(routes, lastPoints);







    
    
    actionKinds = [1 2 3 5 6 7];
    
    [BestSol, BestCost] = tabuSearch(idRoutes, startingPoint, points, ...
                             vehiclesCapacity, nVehicles, weights, MaxIt, ...
                             actionKinds, verboseFlag);
    actionKinds = [1 2 3];
    
    [BestSol2, BestCost2] = tabuSearch(idRoutes, startingPoint, points, ...
                             vehiclesCapacity, nVehicles, weights, MaxIt, ...
                             actionKinds, verboseFlag);
    
    %% Resultati e Plot
    
    % plot della soluzione trovata
    name = ['Iterativo configurazione 4, test' num2str(nTest)];
    fig = figure("Name", name);
    hold on
    startingIndex = 1;
    for i = 1:nVehicles
        currColor = [i/nVehicles 0 (nVehicles-i)/nVehicles];
        currRoute = [startingPoint; 
                     points(BestSol2.Position(startingIndex:BestSol2.LastPoints(i)),:); 
                     startingPoint];
        startingIndex = BestSol2.LastPoints(i)+1;
        plot(currRoute(:,1), currRoute(:,2), "Color", currColor, "LineStyle", "--");
    end
    hold off
    exportgraphics(fig,[pwd '/images/iterativoConf4Test' num2str(nTest) '.png'],'Resolution',300)
    costi(4,nTest) = costFunction(BestSol2.Position, BestSol2.LastPoints);
    % plot della soluzione trovata
    name = ['Iterativo configurazione 5, test' num2str(nTest)];
    fig = figure("Name", name);
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
    exportgraphics(fig,[pwd '/images/iterativoConf5Test' num2str(nTest) '.png'],'Resolution',300)
    costi(5,nTest) = costFunction(BestSol.Position, BestSol.LastPoints);
    % plot dei costi
    name = ['Costi iterativo configurazione 4, test' num2str(nTest)];
    fig = figure("Name", name);
    hold on
    plot(BestCost2, 'LineWidth', 2);
    if iscell(optSol)
        plot(optCost*ones(MaxIt,1), 'LineWidth', 2, 'LineStyle','--', 'Color','r');
    end
    xlabel('Iteration');
    ylabel('Best Cost'); 
    ylim(curryLimit);
    grid on;
    hold off
    exportgraphics(fig,[pwd '/images/costiIterativoConf4Test' num2str(nTest) '.png'],'Resolution',300)

    % plot dei costi
    name = ['Costi iterativo configurazione 5, test' num2str(nTest)];
    fig = figure("Name", name);
    hold on
    plot(BestCost, 'LineWidth', 2);
    if iscell(optSol)
        plot(optCost*ones(MaxIt,1), 'LineWidth', 2, 'LineStyle','--', 'Color','r');
    end
    xlabel('Iteration');
    ylabel('Best Cost'); 
    ylim(curryLimit);
    grid on;
    hold off
    exportgraphics(fig,[pwd '/images/costiIterativoConf5Test' num2str(nTest) '.png'],'Resolution',300)













    actionKinds = [1 2 3 5 6 7];
    
    [BestSol, BestCost] = tabuSearch(idRoutes2, startingPoint, points, ...
                             vehiclesCapacity, nVehicles, weights, MaxIt, ...
                             actionKinds, verboseFlag);
    actionKinds = [1 2 3];
    
    [BestSol2, BestCost2] = tabuSearch(idRoutes2, startingPoint, points, ...
                             vehiclesCapacity, nVehicles, weights, MaxIt, ...
                             actionKinds, verboseFlag);
    
    %% Resultati e Plot
    
    % plot della soluzione trovata
    name = ['Iterativo configurazione 6, test' num2str(nTest)];
    fig = figure("Name", name);
    hold on
    startingIndex = 1;
    for i = 1:nVehicles
        currColor = [i/nVehicles 0 (nVehicles-i)/nVehicles];
        currRoute = [startingPoint; 
                     points(BestSol2.Position(startingIndex:BestSol2.LastPoints(i)),:); 
                     startingPoint];
        startingIndex = BestSol2.LastPoints(i)+1;
        plot(currRoute(:,1), currRoute(:,2), "Color", currColor, "LineStyle", "--");
    end
    hold off
    exportgraphics(fig,[pwd '/images/iterativoConf6Test' num2str(nTest) '.png'],'Resolution',300)
    costi(6,nTest) = costFunction(BestSol2.Position, BestSol2.LastPoints);

    % plot della soluzione trovata
    name = ['Iterativo configurazione 7, test' num2str(nTest)];
    fig = figure("Name", name);
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
    exportgraphics(fig,[pwd '/images/iterativoConf7Test' num2str(nTest) '.png'],'Resolution',300)
    costi(7,nTest) = costFunction(BestSol.Position, BestSol.LastPoints);
    % plot dei costi
    name = ['Costi iterativo configurazione 6, test' num2str(nTest)];
    fig = figure("Name", name);
    hold on
    plot(BestCost2, 'LineWidth', 2);
    if iscell(optSol)
        plot(optCost*ones(MaxIt,1), 'LineWidth', 2, 'LineStyle','--', 'Color','r');
    end
    xlabel('Iteration');
    ylabel('Best Cost'); 
    ylim(curryLimit);
    grid on;
    hold off
    exportgraphics(fig,[pwd '/images/costiIterativoConf6Test' num2str(nTest) '.png'],'Resolution',300)

    % plot dei costi
    name = ['Costi iterativo configurazione 7, test' num2str(nTest)];
    fig = figure("Name", name);
    hold on
    plot(BestCost, 'LineWidth', 2);
    if iscell(optSol)
        plot(optCost*ones(MaxIt,1), 'LineWidth', 2, 'LineStyle','--', 'Color','r');
    end
    xlabel('Iteration');
    ylabel('Best Cost'); 
    ylim(curryLimit);
    grid on;
    hold off
    exportgraphics(fig,[pwd '/images/costiIterativoConf7Test' num2str(nTest) '.png'],'Resolution',300)
    
end
costi = costi';
gap = (costi-costi(:,1))./costi(:,1)*100;
writematrix(costi, 'costi2.csv');
writematrix(gap, 'gap2.csv');