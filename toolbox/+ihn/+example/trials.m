function trials
window = ihn.createWindowForPropixx();

% ihn.runAllTrials expects trials to be any collection with paren indexing. Create some trials each with a word to present.
trials(3).word = 'who';
trials(2).word = 'what';
trials(1).word = 'where';

% escape key will exit early
ihn.runAllTrials(@runTrial, trials);

    % ihn.runAllTrials expects trialFunction to accept a single argument
    % representing one element of the trials collection
    function runTrial(trial)
        white = [255, 255, 255];
        for i = 1:120
            ihn.drawFixation(window, white);
            Screen('Flip', window.pointer);
        end
        for i = 1:120
            DrawFormattedText(window.pointer, trial.word, 'center', 'center', white);
            Screen('Flip', window.pointer);
        end
    end
end

