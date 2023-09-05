function bench
window = ihn.createWindowForPropixx();
durationSeconds = 0.5;
iterations = 10;
candidate(1).name = 'trustGPU';
candidate(1).f = @trustGPU;
candidate(2).name = 'trustCPU';
candidate(2).f = @trustCPU;
candidate(3).name = 'blocking';
candidate(3).f = @blocking;
comparisons = 5;
for j = 1:comparisons
    stream = RandStream('mt19937ar', 'Seed', 'Shuffle');
    candidate = candidate(stream.randperm(numel(candidate)));
    fprintf('target\n');
    fprintf('  duration (s): %g\n', durationSeconds);
    for i = 1:numel(candidate)
        metrics(candidate(i).name, tbd(window, durationSeconds, iterations, candidate(i).f), durationSeconds);
    end
end
end

function elapsed = tbd(window, durationSeconds, iterations, f)
frameRateHz = Screen('FrameRate', window.pointer);
elapsed = zeros(1, iterations);
for i = 1:iterations
    % Show
    Screen('Flip', window.pointer);
    s = GetSecs();

    f(window, durationSeconds, frameRateHz);

    % Clear
    Screen('Flip', window.pointer);
    n = GetSecs();
    elapsed(i) = n - s;
end
end

function trustGPU(window, durationSeconds, frameRateHz)
for j = 1:round(frameRateHz * durationSeconds)-1
    Screen('Flip', window.pointer);
end
end

function trustCPU(window, durationSeconds, frameRateHz)
s = GetSecs();
while GetSecs() - s < durationSeconds - 1.5/frameRateHz
    Screen('Flip', window.pointer);
end
end

function blocking(~, durationSeconds, ~)
WaitSecs(durationSeconds);
end

function metrics(name, elapsed, target)
fprintf('%s\n', name);
fprintf('  min: %g\n', min(elapsed));
fprintf('  max: %g\n', max(elapsed));
fprintf('  mean: %g\n', mean(elapsed));
fprintf('  std: %g\n', std(elapsed));
fprintf('  mse: %g\n', mean((elapsed - target).^2));
end