function main(trigger, trialPath)
if nargin < 2
    trialPath = 'Trial_Info_Flanker.csv';
end
if nargin < 1
    trigger = ihn.createSerialPort();
end
trialTable = readtable(trialPath);
trials = arrayfun(@(row)convertRowToTrial(trialTable(row, :)), 1:height(trialTable));

window = ihn.createWindowForPropixx();
frameRateHz = Screen('FrameRate', window.pointer);

% First call to DrawFormattedText is slow
DrawFormattedText(window.pointer, 'Loading...', 'center', 'center', [255, 255, 255]);
Screen('Flip', window.pointer);
textureCache = ihn.Cache(...
    [arrayfun(@(trial)string(trial.imageName), trials), "Practice_Instructions.tif", "Fixation.tif", "Break.tif", "End.tif"],...
    @(path)Screen('MakeTexture', window.pointer, imread(fullfile('image', path))));

task = ihn.VisualTask(window.pointer);
task.addToTrial(@fixation, @(trial)trial.baselineMilliseconds/1000, 30);
task.addToTrial(@stimulus, 2, @(trial)trial.trigger);
task.before(@instructions, 5);
task.middle(@showBreak, 30);
task.after(@after, 2);
task.run(trials);

    function instructions
        Screen('DrawTexture', window.pointer, textureCache.at('Practice_Instructions.tif'));
    end

    function fixation(~)
        Screen('DrawTexture', window.pointer, textureCache.at('Fixation.tif'));
    end

    function stimulus(trial)
        Screen('DrawTexture', window.pointer, textureCache.at(trial.imageName));
    end

    function showBreak
        Screen('DrawTexture', window.pointer, textureCache.at('Break.tif'));
    end

    function after
        Screen('DrawTexture', window.pointer, textureCache.at('End.tif'));
    end
end

function trial = convertRowToTrial(row)
trial.imageName = row.Stim_File{1};
trial.baselineMilliseconds = row.Baseline;
trial.trigger = row.Trigger;
end

