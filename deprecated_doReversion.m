% Codice elaborato a partire da quello di
% Mostapha Kalami Heris, Tabu Search (TS) in MATLAB (URL: https://yarpiz.com/243/ypea116-tabu-search), Yarpiz, 2015.

function [q, lq] = doReversion(p, lp, w, c, i1, i2)
    % inverte l'ordine dei punti da i1 a i2
    % per come è stato costruito l'insieme delle azioni, i2 è sempre piu'
    % grande di i1
    q = p;
    lq = lp;
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
    lq(end) = length(q);
    % alternativamente, sarebbe stato possibile spostare i punti dopo
    % lq(end) al primo route, ma la stessa situazione si puo' ottenere
    % combinando più reversion:
        % reversion di tutti i punti. il primo route ora è l'ultimo
        % reversion dei primi nVehicles - 1 tragitti
        % reversion dell'ultimo route
        % ad esempio se ci fossero 5 veicoli, i route sarebbero passati da
        % 1 2 3 4 5 a 2 3 4 5 1, ognuno nello stesso ordine di partenza.
        % la value function non è mai cambiata, quindi eventualmente la
        % tabu search è in grado di arrivare a questa situazione
        % effettuare un reversion che comprenda anche il route 1, e
        % riordinare nuovamente il tutto alla situazione iniziale
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