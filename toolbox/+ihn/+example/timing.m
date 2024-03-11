function timing
window = ihn.createMRIWindow();
frameRateHz = Screen('NominalFrameRate', window.pointer);

trials(3).word = 'who';
trials(2).word = 'what';
trials(1).word = 'where';

Screen('Flip', window.pointer);
a = GetSecs();
ihn.runAllTrials(@(trial)runTrial(@()ihn.RobustTiming(frameRateHz), trial), trials);
Screen('Flip', window.pointer);
b = GetSecs();
ihn.runAllTrials(@(trial)runTrial(@()ihn.PreciseTiming(frameRateHz), trial), trials);
Screen('Flip', window.pointer);
c = GetSecs();
fprintf('Robust Timing: %d\n', b - a);
fprintf('Precise Timing: %d\n', c - b);

    function runTrial(makeTiming, trial)
        white = [255, 255, 255];
        timing = makeTiming();
        while ~timing.nextFlipWillBeNear(1000)
            DrawFormattedText(window.pointer, trial.word, 'center', 'center', white);
            Screen('Flip', window.pointer);
            timing.onFlip();
        end
    end
end