function window = createOnFurthestScreen(create)
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference', 'VisualDebugLevel', 0);
window = create(max(Screen('Screens')));
end