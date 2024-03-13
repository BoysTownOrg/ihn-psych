function runHighPriorityTask(trialFunction, trials, options)
    arguments
        trialFunction
        trials
        options.timeoutSeconds = inf
        options.preFunction = @()[]
        options.halfwayFunction = @()[]
        options.postFunction = @()[]
    end
KbName('UnifyKeyNames');
escapeKey = KbName('escape');
% First call to KbCheck is slow
[~, ~, ~] = KbCheck();

priority = ihn.ScopedHighPriority; %#ok<NASGU>
options.preFunction();
s = GetSecs();
for i = 1:numel(trials)
    trialFunction(trials(i));

    if GetSecs() - s > options.timeoutSeconds
        break
    end

    [~, ~, keyCodes] = KbCheck;
    if keyCodes(escapeKey)
        return
    end

    if ceil(numel(trials) / 2) == i
        options.halfwayFunction();
    end
end
options.postFunction();
end
