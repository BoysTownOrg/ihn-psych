function runAllTrials(trialFunction, trials, onHalfway)
if nargin < 3
    onHalfway = @()[];
end
ihn.runHighPriorityTask(trialFunction, trials,...
    'halfwayFunction', onHalfway);
end
