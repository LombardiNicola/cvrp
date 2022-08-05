function l = tourLength(ids, lastPoints, points, startingPoint)
    nTours = length(lastPoints);
    l = 0;
    lastPoint = 0;
    for i = 1:nTours
        firstPoint = lastPoint + 1;
        lastPoint = lastPoints(i);
        curr = [startingPoint; points(ids(firstPoint:lastPoint),:); startingPoint];
        diffs = diff(curr);
        l = l + sum(sqrt(sum(diffs.^2,2)));
    end
end

