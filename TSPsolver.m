function [sol,minDist,exitflag,output] = TSPsolver (distance) 
    % input checks
    checkValidDistanceMatrix(distance,1e-8);

    % based on MilkCollection_by_GiulioMerlo.mlx
    n = length(distance(1,:));
    problem = optimproblem('ObjectiveSense', 'min');
    travelledArcs = optimvar('travelledArcs', n, n, ...
        'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1);
    antiSubTourVar = optimvar('antiSubTourVar', n - 1, ...
        'Type', 'integer', 'LowerBound', 0);
    
    problem.Objective = sum(travelledArcs(:, :) .* distance, 'all');
    
    intoConstraint = optimconstr(n);
    for i = 1:n
        intoConstraint(i) = sum(travelledArcs(:, i)) == 1;
    end

    problem.Constraints.IntoConstr = intoConstraint;
    
    out_ofConstraint = optimconstr(n);
    for i = 1:n
        out_ofConstraint(i) = sum(travelledArcs(i, :)) == 1;
    end
    
    problem.Constraints.Out_ofConstr = out_ofConstraint;
    
    subtourElimination = optimconstr(n - 1, n - 1);
    for j = 2:n
        for i = 2:n
            subtourElimination(i - 1, j - 1) = antiSubTourVar(i - 1) - antiSubTourVar(j - 1) ...
                + n * travelledArcs(i, j) <= n - 1;
        end
    end
    problem.Constraints.SubtourElimination = subtourElimination;
    
    diagConstr = optimconstr(n);
    for i = 1:n
        diagConstr(i) = travelledArcs(i, i) == 0; 
    end
    problem.Constraints.DiagConstr = diagConstr;
    [sol,minDist,exitflag,output] = solve(problem);
end

