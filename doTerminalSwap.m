function [q, lq] = doTerminalSwap(p, lp, w, c, i1, i2, nPoints1, nPoints2)
    % prende l'inizio (o la fine a seconda del segno di i2) del route
    % i2 e prova a scambiarlo con l'inizio (o la fine) di i1
    q = p;
    lq = lp;
    
    s1 = sign(i1);
    s2 = sign(i2);
    i1 = i1*s1;
    i2 = i2*s2;

    % controllo se ci sono abbastanza punti
    len1 = 0;
    firstPoint1 = 0;
    if i1 == 1
        len1 = lp(i1);
        firstPoint1 = 1;
    else
        len1 = lp(i1) - lp(i1-1);
        firstPoint1 = lp(i1-1) + 1;
    end
    if len1 < nPoints1
        return
    end

    len2 = 0;
    firstPoint2 = 0;
    if i2 == 1
        len2 = lp(i2);
        firstPoint2 = 1;
    else
        len2 = lp(i2) - lp(i2-1);
        firstPoint2 = lp(i2-1) + 1;
    end
    if len2 < nPoints2
        return
    end

    % estremi degli intervalli da spostare
    temp1 = [];
    if s1 > 0
        % inizio del route
        temp1 = q(firstPoint1:(firstPoint1 + nPoints1 - 1));
        q(firstPoint1:(firstPoint1 + nPoints1 - 1)) = [];
    else
        %fine del route
        temp1 = q((lq(i1) - nPoints1 + 1):lq(i1));
        q((lq(i1) - nPoints1 + 1):lq(i1)) = [];
    end

    lq(i1:end) = lq(i1:end) - nPoints1;
    if i2 > i1
        firstPoint2 = firstPoint2 - nPoints1;
    end

    temp2 = [];
    if s2 > 0
        % inizio del route
        temp2 = q(firstPoint2:(firstPoint2 + nPoints2 - 1));
        q(firstPoint2:(firstPoint2 + nPoints2 - 1)) = [];
    else
        %fine del route
        temp2 = q((lq(i2) - nPoints2 + 1):lq(i2));
        q((lq(i2) - nPoints2 + 1):lq(i2)) = [];
    end
    % aggiorno q e lq
    lq(i2:end) = lq(i2:end) - nPoints2;

    
    % inserisco temp1
    if s2 > 0
        % inizio del route
        if i2 == 1
            q = [temp1; q];
        else
            q = [q(1:lq(i2-1)); temp1; q((lq(i2-1)+1):end)];
        end
    else
        % fine del route
        q = [q(1:lq(i2)); temp1; q((lq(i2)+1):end)];
    end
    lq(i2:end) = lq(i2:end) + nPoints1;

    % inserisco temp2
    if s1 > 0
        % inizio del route
        if i1 == 1
            q = [temp2; q];
        else
            q = [q(1:lq(i1-1)); temp2; q((lq(i1-1)+1):end)];
        end
    else
        % fine del route
        q = [q(1:lq(i1)); temp2; q((lq(i1)+1):end)];
    end
    lq(i1:end) = lq(i1:end) + nPoints2;

    % check feasibility
    upperLimit1 = lq(i1);
    if i1 == 1
        lowerLimit1 = 1;
    else
        lowerLimit1 = lq(i1-1) + 1;
    end
    if sum(w(q(lowerLimit1:upperLimit1))) > c
        q = p;
        lq = lp;
        return
    end
    upperLimit2 = lq(i2);
    if i2 == 1
        lowerLimit2 = 1;
    else
        lowerLimit2 = lq(i2-1) + 1;
    end
    if sum(w(q(lowerLimit2:upperLimit2))) > c
        q = p;
        lq = lp;
        return
    end
end