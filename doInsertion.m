% Codice elaborato a partire da quello di
% Mostapha Kalami Heris, Tabu Search (TS) in MATLAB (URL: https://yarpiz.com/243/ypea116-tabu-search), Yarpiz, 2015.

function [q, lq] = doInsertion(p, lp, w, c, i1, i2)
    % prende il punto in posizione i1 e lo sposta in posizione i2
    % non si fa nulla se i1 e i1-1 sono in lp, 
    % in quanto il route da cui andiamo a prelevare i1 avrebbe solo questo
    % come punti
    lq = lp;
    if sum(lp == i1) && sum(lp == (i1-1))
        q = p;
        return
    end
    if i1 < i2
        % -e indica il punto finale di un percorso
        % la situazione è del tipo:
        % -e -- -- i1 -- -e -- -- -e i2
        % a4 b1 b2 b3 b4 b5 c1 c2 c3 d1
        % quindi biogna ottenere
        % -e -- -- -- -e -- -- -e -- --
        % a4 b1 b2 b4 b5 c1 c2 c3 d1 b3
        q = p([1:i1-1 i1+1:i2 i1 i2+1:end]);
        % aggiornamento dei lastPoints
        lq(lq >= i1 & lq < i2) = lq(lq >= i1 & lq < i2) - 1;
    else
        % la situazione è del tipo:
        % -e -- -- i2 -- -e -- -- -e i1
        % a4 b1 b2 b3 b4 b5 c1 c2 c3 d1
        % quindi biogna ottenere
        % -e -- -- -- -- -- -e -- -- -e
        % a4 b1 b2 b3 d1 b4 b5 c1 c2 c3 
        q = p([1:i2 i1 i2+1:i1-1 i1+1:end]);
        % aggiornamento dei lastPoints
        lq(lq >= i2 & lq < i1) = lq(lq >= i2 & lq < i1) + 1;
    end

    % check feasability
    upperLimit = min(lq(lq >= i2));
    lowerLimit = max([0; lq(lq < i2)]) + 1;
    if sum(w(q(lowerLimit:upperLimit))) > c
        % la soluzione ottenuta non rispetta i vincoli di capacità,
        % torniamo alla situazione di partenza
        q = p;
        lq = lp;
        return
    end
end