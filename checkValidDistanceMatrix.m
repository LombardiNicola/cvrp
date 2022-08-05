function [] = checkValidDistanceMatrix(distance, tol)
    if ~isnumeric(distance)
        error('Error: input "distance" must have numeric values')
    end
    if sum(distance < 0)
        error('Error: input "distance" must contain non-negative values only')
    end
    % check matrice quadrata
    if diff(size(distance))
        error('Error: input "distance" must be a square matrix')
    end
    n = length(distance(1,:));
    % simmetrica
    if ~issymmetric(distance)
        error('Error: input "distance" must be a symmetric matrix')
    end
    % diagonale nulla
    if sum(diag(distance) ~= zeros(n, 1))
        error('Error: input "distance" must have all-zeros diagonal')
    end
    % disuguaglianza traingolare
    for i = 1:n
        for j = (i+1):n
            for k = 1:n
                if distance(i,j) > distance(i,k) + distance(k,j) + tol
                    error('Error: input "distance" does not satisfy triangular inequality')
                end
            end
        end
    end
end