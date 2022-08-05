function [q, lq] = doMoveEnding(p, lp, w, c, i1, i2)
    % rimpiazza il valore di lp in i2 (indice di veicolo) 
    % con i1 (indice di posizione dell'estremo)
    q = p;
    lq = lp;
    if sum(lq == i1)
        % lq non può contenere ripetizioni, altrimenti si avrebbe un
        % percorso vuoto
        return
    end
    old = lq(i2);
    lq(i2) = [];
    lq = [lq(lq < i1); i1; lq(lq > i1)];

    % check feasability
    upperLimit = min(lq(lq >= old));
    lowerLimit = max([0; lq(lq < old)]) + 1;

    if sum(w(q(lowerLimit:upperLimit))) > c
        q = p;
        lq = lp;
        return
    end
end