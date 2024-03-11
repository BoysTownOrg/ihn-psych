function audio(deviceName)
if nargin < 1
    % audio device used in MEG room
    deviceName = 'SPL Crimson';
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
while true
    status = PsychPortAudio('GetStatus', playback.handle);
    if ~status.Active
        return
    end
end
end