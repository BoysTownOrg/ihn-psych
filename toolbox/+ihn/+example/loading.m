function loading
window = ihn.createWindowForPropixx();
filePaths = collectFilePaths();
cache = ihn.Cache(filePaths, @(path)loadFile(path), @(i)updateWindow(window, i, numel(filePaths)));

% Access the cached data associated with a file.
data = cache.at(filePaths(1)); %#ok<NASGU> 
end

function paths = collectFilePaths()
% ihn.Cache expects an array of strings, likely a collection of file
% paths.

% Generate fake paths.
paths = arrayfun(@(i)string(num2str(i)), 1:120);
end

function data = loadFile(path) %#ok<INUSD> 
% You would likely use audioread or Screen('MakeTexture', ...) and imread,
% i.e.
%
% data = audioread(path);
% 
% or
%
% data = Screen('MakeTexture', window.pointer, imread(path)));

% Simulate I/O delay
WaitSecs(0.015);
data = [];
end

function updateWindow(window, i, total)
white = [255, 255, 255];
DrawFormattedText(window.pointer, sprintf('Loading %d of %d', i, total), 'center', 'center', white);
% You may not want to flip for every file, as doing so adds latency.
Screen('Flip', window.pointer);
end
