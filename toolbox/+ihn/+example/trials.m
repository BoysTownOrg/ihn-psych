function trials
window = ihn.createMEGWindow();

% ihn.runHighPriorityTask expects trials to be any collection with paren indexing. Create some trials each with a word to present.
trials(3).word = 'who';
trials(2).word = 'what';
trials(1).word = 'where';

white = [255, 255, 255];
frameRateHz = Screen('FrameRate', window.pointer);
halfFrameSeconds = 0.5/frameRateHz;
vbl = Screen('Flip', window.pointer);
% escape key will exit early
ihn.runHighPriorityTask(@runTrial, trials, 'postFunction', @allowResponse);

    % ihn.runHighPriorityTask expects trialFunction to accept a single argument
    % representing one element of the trials collection
    function runTrial(trial)
        fixation;
        stimulus(trial);
    end

    function fixation
        ihn.drawFixation(window, white);
        vbl = Screen('Flip', window.pointer, vbl + 2 - halfFrameSeconds);
    end

    function stimulus(trial)
        DrawFormattedText(window.pointer, trial.word, 'center', 'center', white);
        vbl = Screen('Flip', window.pointer, vbl + 2 - halfFrameSeconds);
    end

    function allowResponse
        fixation;
        Screen('Flip', window.pointer, vbl + 2 - halfFrameSeconds);
    end
end

