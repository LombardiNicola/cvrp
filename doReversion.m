% Codice elaborato a partire da quello di
% Mostapha Kalami Heris, Tabu Search (TS) in MATLAB (URL: https://yarpiz.com/243/ypea116-tabu-search), Yarpiz, 2015.

function [q, lq] = doReversion(p, lp, w, c, i1, i2)
    % inverte l'ordine dei punti da i1 a i2
    % per come è stato costruito l'insieme delle azioni, i2 è sempre piu'
    % grande di i1
    q = p;
    lq = lp;
    n = lp(end);
    % ad esempio da
    % -e -- -- i1 -- -e -- -- -e i2
    % a4 b1 b2 b3 b4 b5 c1 c2 c3 d1
    % si ottiene
    % -e -- -- -e -- -- -e -- -- --
    % a4 b1 b2 d1 c3 c2 c1 b5 b4 b3

    % l'esempio inoltre permette di notare come sia necessario diminuire di
    % 1 gli elementi di lq per conservare il route interno (c1 c2 c3)

    % iMin = min(i1,i2);
    % iMax = max(i1,i2);
    iMin = i1;
    iMax = i2;
    q(iMin:iMax) = p(iMax:-1:iMin);
    temp = lq(lq <= iMax & lq >= iMin);
    temp = temp(end:-1:1);
    lq(lq <= iMax & lq >= iMin) = iMin + (iMax - temp) - 1;
    % lq(end) potrebbe essere stato modificato: mi assicuro che non vadano
    % persi dei punti
    % quanti punti eventualmente sono finiti dopo l'ultimo lastPoint
    % fare così permette di avere circolarità tra i vari cluster
    lastEnd = lq(end);
    if ~(sum(lp == i2) && sum(lp == i1-1))
        delta = n - lastEnd; 
        % traslazione dei punti, dei valori di lq, i1 e i2
        q = [q((lastEnd + 1):n); q(1:lastEnd)];
        lq = lq + delta;
        i1 = i1 + delta;
        i2 = mod(i2 + delta, length(p));
    else
        % inversione completa di routes
        lq(lp == i2) = i2;
    end
    % check feasability
    upperLimit = min(lq(lq >= i2));
    lowerLimit = max([0; lq(lq < i2)]) + 1;
    if sum(w(q(lowerLimit:upperLimit))) > c
        q = p;
        lq = lp;
        return
    end
    upperLimit1 = min(lq(lq >= i1));
    lowerLimit1 = max([0; lq(lq < i1)]) + 1;
    if sum(w(q(lowerLimit1:upperLimit1))) > c
        q = p;
        lq = lp;
        return
    end
end