function trials
window = ihn.createMEGWindow();

trials(3).word = 'who';
trials(2).word = 'what';
trials(1).word = 'where';

white = [255, 255, 255];

task = ihn.VisualTask(window.pointer);
task.addToTrial(@fixation, 2);
task.addToTrial(@stimulus, 2);
task.after(@fixation, 2);
task.run(trials);

    function fixation(~)
        ihn.drawFixation(window, white);
    end

    function stimulus(trial)
        DrawFormattedText(window.pointer, trial.word, 'center', 'center', white);
    end
end

