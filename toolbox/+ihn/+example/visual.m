function visual
window = ihn.createMEGWindow();
for i = 1:120
    white = [255, 255, 255];
    ihn.drawFixation(window, white);
    Screen('Flip', window.pointer);
end
end