function window = createWindowForPropixx
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference', 'VisualDebugLevel', 0);
screenNumber = max(Screen('Screens'));
window = ihn.Window(screenNumber);
end
