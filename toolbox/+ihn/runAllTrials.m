function runAllTrials(trialFunction, trials, onHalfway)
KbName('UnifyKeyNames');
escapeKey = KbName('escape');
% First call to KbCheck is slow
[~, ~, ~] = KbCheck();

priority = ihn.ScopedHighPriority; %#ok<NASGU>
for i = 1:numel(trials)
    trialFunction(trials(i));

    [~, ~, keyCodes] = KbCheck;
    if keyCodes(escapeKey)
        return
    end

    if ceil(numel(trials) / 2) == i && nargin > 2
        onHalfway();
    end
end
end
