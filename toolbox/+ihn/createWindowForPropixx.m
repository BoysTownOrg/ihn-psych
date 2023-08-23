function window = createWindowForPropixx
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference', 'VisualDebugLevel', 0);
propixxScreen = max(Screen('Screens'));
window = ihn.Window(propixxScreen);
end
