classdef StereoAudioPlayback < handle
    properties
        handle
    end

    methods
        function self = StereoAudioPlayback(index, fs)
            playback = 1;
            aggressive = 4;
            stereo = 2;
            self.handle = PsychPortAudio('Open', index, playback, aggressive, fs, stereo);
        end

        function delete(self)
            PsychPortAudio('Close', self.handle);
        end
    end
end

