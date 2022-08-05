function actionList = createActionList(n, nVehicles, actionKinds, verboseFlag)
    % Actions:
    % swap scambia 2 elementi
    % reversion inverte un insieme contiguo di indici
        % la sezione puo' estendersi anche su più routes, risultando in uno
        % scambio della fine di un route con l'inizio di un altro, nonchè
        % di invertire l'ordine di percorrenza dei routes
        % reversion cambia gli indici lastPoints
    % insertion prende un punto e lo sposta in una determinata posizione
        % e' necessario prestare attenzione agli indici lastPoints, in
        % quanto potrebbero variare, e a non lasciare vuoti dei route
    % moveEnding cambia la posizione della fine dei routes. L'ultimo
        % lastIndex sarà sempre n, quindi non ha senso modificarlo o
        % permettere di cambiare un last index ad n
        % moveEnding in diversi casi test ha portato a peggioramenti delle
        % performance della tabuSearch

    nSwap = n*(n-1)/2;
    nReversion = n*(n-1)/2;
    nInsertion = n^2;
    nMoveEnding = (nVehicles-1)*(n-1);
    nRouteSwap = nVehicles*(nVehicles-1)/2;
    nTerminalChanges = nVehicles^2*9*4; % sovrastima
    nTerminalSwaps = nVehicles^2*9*4; % sovrastima
    nAction = nSwap + nReversion + nInsertion + nMoveEnding + nRouteSwap ...
        + nTerminalChanges+ nTerminalSwaps;
    actionList = cell(nAction, 1);
    
    c = 0;
    if sum(actionKinds == 1)
        % Add SWAP
        if verboseFlag
            disp(' - SWAPs');
        end
        for i = 1:n-1
            for j = i+1:n
                c = c+1;
                actionList{c} = [1 i j];
            end
        end
    end

    if sum(actionKinds == 2)
        % Add REVERSION (se |i-j|<3 allora è uno swap)
        if verboseFlag
            disp(' - REVERSIONs');
        end
        for i = 1:n-3
            for j = i+3:n
                c = c+1;
                actionList{c} = [2 i j];
            end
        end
    end

    if sum(actionKinds == 3)
        % Add INSERTION
        if verboseFlag
            disp(' - INSERTIONs');
        end
        for i = 1:n-2
            for j = i+2:n
                c = c + 1;
                actionList{c} = [3 i j];
                c = c + 1;
                actionList{c} = [3 j i];
            end
        end
    end

    if sum(actionKinds == 4)
        % Add MOVEENDING peggiora le performance in molti casi test 
        if verboseFlag
            disp(' - MOVEENDINGs');
        end
        for i = 1:n-1
            for j = 1:nVehicles-1
                c = c + 1;
                actionList{c} = [4 i j];
            end
        end
    end

    if sum(actionKinds == 5)
        % Add ROUTESSWAP
        if verboseFlag
            disp(' - ROUTESWAPs');
        end
        for i = 1:nVehicles-1
            for j = i+1:nVehicles
                c = c+1;
                actionList{c} = [5 i j];
            end
        end
    end

    % i punti più vicini al deposito tendono ad essere gestiti in maniera
    % particolarmente inefficiente, quindi proviamo delle azioni specifiche
    % per inizio e fine dei routes

    if sum(actionKinds == 6)
        % Add TERMINALCHANGE
        if verboseFlag
            disp(' - TERMINALCHANGEs');
        end
        for i = 1:nVehicles
            for j = 1:nVehicles
                for k = 2:4
                    actionList{c} = [6 i -j k];
                    if i == j
                        break
                    end
                    c = c+1;
                    actionList{c} = [6 i j k];
                    c = c+1;
                    actionList{c} = [6 -i j k];
                    c = c+1;
                    actionList{c} = [6 -i -j k];
                end
            end
        end
    end

    if sum(actionKinds == 7)
        % Add TERMINALSWAP
        if verboseFlag
            disp(' - TERMINALSWAPs');
        end
        for i = 1:nVehicles
            for j = i:nVehicles
                for k1 = 1:3
                    for k2 = 1:3
                        if k1 == 1 && k2 == 1
                            break
                        end
                        actionList{c} = [7 i -j k1 k2];
                        if i == j
                            break
                        end
                        c = c+1;
                        actionList{c} = [7 i j k1 k2];
                        c = c+1;
                        actionList{c} = [7 -i j k1 k2];
                        c = c+1;
                        actionList{c} = [7 -i -j k1 k2];
                    end
                end
            end
        end
    end
    
    actionList = actionList(1:c);
end