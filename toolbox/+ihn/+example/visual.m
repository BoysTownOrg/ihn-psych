function visual
window = ihn.createMEGWindow();
frameRateHz = Screen('FrameRate', window.pointer);
halfFrameSeconds = 0.5/frameRateHz;

white = [255, 255, 255];
ihn.drawFixation(window, white);
vbl = Screen('Flip', window.pointer);
durationSeconds = 2;
Screen('Flip', window.pointer, vbl + durationSeconds - halfFrameSeconds);
end
