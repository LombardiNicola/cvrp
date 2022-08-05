function [q, lq] = doTerminalChange(p, lp, w, c, i1, i2, nPoints)
    % prende l'inizio (o la fine a seconda del segno di i2) del route
    % i2 e prova a metterlo all'inizio (o alla fine) di i1
    q = p;
    lq = lp;
    
    s1 = sign(i1);
    s2 = sign(i2);
    i1 = i1*s1;
    i2 = i2*s2;

    % controllo se ci sono abbastanza punti
    len2 = 0;
    firstPoint = 0;
    if i2 == 1
        len2 = lp(i2);
        firstPoint = 1;
    else
        len2 = lp(i2) - lp(i2-1);
        firstPoint = lp(i2-1) + 1;
    end
    if len2 <= nPoints
        return
    end
    
    temp = [];
    % estremi dell'intervallo da spostare
    if s2 > 0
        % inizio del route
        temp = q(firstPoint:(firstPoint + nPoints - 1));
        q(firstPoint:(firstPoint + nPoints - 1)) = [];
    else
        % fine del route
        temp = q((lp(i2) - nPoints + 1):lp(i2));
        q((lp(i2) - nPoints + 1):lp(i2)) = [];
    end
    % aggiorno q e lq
    lq(i2:end) = lq(i2:end) - nPoints;
    if s1 > 0
        % inizio del route
        if i1 == 1
            q = [temp; q(1:end)];
        else
            q = [q(1:(lq(i1-1))); temp; q((lq(i1-1)+1):end)];
        end
    else
        % fine del route
        q = [q(1:(lq(i1))); temp; q((lq(i1)+1):end)];
    end
    lq(i1:end) = lq(i1:end) + nPoints;

    % check feasibility
    upperLimit = lq(i1);
    if i1 == 1
        lowerLimit = 1;
    else
        lowerLimit = lq(i1-1) + 1;
    end
    if sum(w(q(lowerLimit:upperLimit))) > c
        q = p;
        lq = lp;
        return
    end
end