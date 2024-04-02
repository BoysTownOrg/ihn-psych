function runHighPriorityTask(trialFunction, trials, varargin)
parser = inputParser;
parser.addParameter('timeoutSeconds', inf);
parser.addParameter('preFunction', @()[]);
parser.addParameter('halfwayFunction', @()[]);
parser.addParameter('postFunction', @()[]);
parser.parse(varargin{:});
KbName('UnifyKeyNames');
escapeKey = KbName('escape');
% First call to KbCheck is slow
[~, ~, ~] = KbCheck();

priority = ihn.ScopedHighPriority; %#ok<NASGU>
parser.Results.preFunction();
s = GetSecs();
for i = 1:numel(trials)
    trialFunction(trials(i));

    if GetSecs() - s > parser.Results.timeoutSeconds
        break
    end

    [~, ~, keyCodes] = KbCheck;
    if keyCodes(escapeKey)
        return
    end

    if ceil(numel(trials) / 2) == i
        parser.Results.halfwayFunction();
    end
end
parser.Results.postFunction();
end
