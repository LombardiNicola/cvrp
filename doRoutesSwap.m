function [q, lq] = doRoutesSwap(p, lp, i1, i2)
    % inverte i routes di indici i1 e i2 (i2 > i1)
    if i1==1
        start1=1;
    else
        start1 = lp(i1-1)+1;
    end
    end1 = lp(i1);
    start2 = lp(i2-1)+1;
    end2 = lp(i2);

    q = [ p(1:(start1-1));
          p(start2:end2);
          p((end1+1):(start2-1));
          p(start1:end1);
          p((end2+1):end) ];
    
    lq = [ lp(1:(i1-1));
           (lp(i1:(i2-1)) - (end1 - start1 + 1) + (end2 - start2 + 1));
           lp(i2:end)    ];
end