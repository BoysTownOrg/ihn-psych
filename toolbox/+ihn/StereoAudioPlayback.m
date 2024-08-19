classdef StereoAudioPlayback < handle
    properties
        handle
    end

    methods
        function self = StereoAudioPlayback(index, fs, varargin)
            parser = inputParser;
            parser.addParameter('aggressiveness', 4);
            parser.parse(varargin{:});
            playback = 1;
            stereo = 2;
            self.handle = PsychPortAudio('Open', index, playback, parser.Results.aggressiveness, fs, stereo);
        end

        function delete(self)
            PsychPortAudio('Close', self.handle);
        end
    end
end

