% Codice elaborato a partire da quello di
% Mostapha Kalami Heris, Tabu Search (TS) in MATLAB (URL: https://yarpiz.com/243/ypea116-tabu-search), Yarpiz, 2015.

function [q,lq] = doSwap(p, lp, w, c, i1, i2)
    % inverte i punti in posizione i1 e i2
    q = p;
    lq = lp;
    q([i1 i2]) = p([i2 i1]);
    
    % check feasability
    if w(p(i1)) > w(p(i2))
        upperLimit = min(lq(lq >= i2));
        lowerLimit = max(lq(lq < i2)) + 1;
    else
        upperLimit = min(lq(lq >= i1));
        lowerLimit = max([0; lq(lq < i1)]) + 1;
    end
    if sum(w(q(lowerLimit:upperLimit))) > c
        q = p;
        lq = lp;
        return
    end
end