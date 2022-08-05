function [] = checkValidParameters(MaxIt, actionKinds, verboseFlag)
    if ~isnumeric(MaxIt) || MaxIt <= 0 || ~floor(MaxIt) == MaxIt
        error('Error: input "MaxIt" must be a positive integer')
    end
    if ~isnumeric(actionKinds) || sum(actionKinds<=0) || ...
            sum(actionKinds>7) || sum(~floor(actionKinds) == actionKinds)
        error('Error: input "actionKinds" must be a sub-array of [1 2 3 4 5 6 7]')
    end
    if ~islogical(verboseFlag)
        error('Error: input "verboseFlag" must be logical')
    end
    if verboseFlag
        disp('All parameters are valid')
    end
end