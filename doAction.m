% Codice elaborato a partire da quello di
% Mostapha Kalami Heris, Tabu Search (TS) in MATLAB (URL: https://yarpiz.com/243/ypea116-tabu-search), Yarpiz, 2015.

function [q, lq] = doAction(p, lp, w, c, a)
    q = p;
    lq = lp;
    
    switch a(1)
        case 1
            % Swap
            [q, lq] = doSwap(p, lp, w, c, a(2), a(3));
            
        case 2
            % Reversion
            [q, lq] = doReversion(p, lp, w, c, a(2), a(3));
            
        case 3
            % Insertion
            [q, lq] = doInsertion(p, lp, w, c, a(2), a(3));

        case 4
            % MoveEnding
            [q, lq] = doMoveEnding(p, lp, w, c, a(2), a(3));

        case 5
            % RoutesSwap
            [q, lq] = doRoutesSwap(p, lp, a(2), a(3));

        case 6
            % TerminalChange
            [q, lq] = doTerminalChange(p, lp, w, c, a(2), a(3), a(4));
            % questa versione inverte l'ordine se necessario, non ci sono
            % variazioni evidenti nel costo della soluzione identificata
            % [q, lq] = doTerminalChange2(p, lp, w, c, a(2), a(3), a(4));

        case 7
            % TerminalSwap
            [q, lq] = doTerminalSwap(p, lp, w, c, a(2), a(3), a(4), a(5));
            % questa versione inverte l'ordine se necessario, non ci sono
            % variazioni evidenti nel costo della soluzione identificata
            % [q, lq] = doTerminalSwap2(p, lp, w, c, a(2), a(3), a(4), a(5));

    end
end