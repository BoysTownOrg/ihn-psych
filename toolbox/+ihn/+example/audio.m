function audio(deviceName)
if nargin < 1
    % audio device used in MEG room
    deviceName = ihn.AudioDeviceName.bothMeg;
end

InitializePsychSound();
index = ihn.findAudioDeviceIndex(deviceName);
Fs = 48000;
playback = ihn.StereoAudioPlayback(index, Fs);
PsychPortAudio('FillBuffer', playback.handle, createAudio(Fs));

playBlocking(playback);
end

function audio = createAudio(Fs)
seconds = 2;
t = ((1:Fs*seconds) - 1)/Fs;
w = hann(numel(t)).';
left = w .* sin(2*pi*440*t);
right = w .* sin(2*pi*660*t);
audio = [left; right];
end

function playBlocking(playback)
waitForStart = 1;
PsychPortAudio('Start', playback.handle, [], [], waitForStart);
waitForEnd = 1;
PsychPortAudio('Stop', playback.handle, waitForEnd);
end
