run(1:numel(trials), {
	@drawFixation, 60, @(i)JitterLengths(i) 
	@drawTarget, @(i)trial_index.target_trigger(i), TargetDur}, {
	@drawFixation, 60, JitterLengths(1)})

%%%

frameRateHz = Screen('FrameRate', wp);
vbl = Screen('Flip', wp);
secs = 0;
for trial = trials
    for visual = visuals
	visual.draw(trial);
	vbl = Screen('Flip', wp, vbl + secs - 0.5/frameRateHz);
	trigger.write(visual.code(trial));
	secs = visual.seconds(trial);
    end
end
post.draw;
vbl = Screen('Flip', wp, vbl + secs - 0.5/frameRateHz);
trigger.write(post.code)
Screen('Flip', wp, vbl + post.seconds - 0.5/frameRateHz);

