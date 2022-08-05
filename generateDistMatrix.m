function dists = generateDistMatrix(points)
    % calcola la distanza euclidea a partire da punti n-dimensionali
    if ~isnumeric(points)
        error('Error, input must be a numeric array')
    end
    l = length(points);
    dists = zeros(l,l);
    for i = 1:l
        for j = (i+1):l
            dists(i,j) = norm(points(i,:) - points(j,:), 2);
            dists(j,i) = norm(points(i,:) - points(j,:), 2);
        end
    end
end