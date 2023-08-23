function audio(deviceName)
if nargin < 1
    deviceName = 'SPL Crimson';
end
index = ihn.findAudioDeviceIndex(deviceName);
Fs = 48000;
playback = ihn.StereoAudioPlayback(index, Fs);
PsychPortAudio('FillBuffer', playback.handle, createAudio(Fs));
waitForStart = 1;
PsychPortAudio('Start', playback.handle, [], [], waitForStart);
while true
    status = PsychPortAudio('GetStatus', playback.handle);
    if ~status.Active
        return
    end
end
end

function audio = createAudio(Fs)
seconds = 2;
t = ((1:Fs*seconds) - 1)/Fs;
w = hann(numel(t)).';
left = w .* sin(2*pi*440*t);
right = w .* sin(2*pi*660*t);
audio = [left; right];
end