classdef ResolutionMatch < handle
    properties (Constant)
        primaryScreen = 0
    end

    properties
        primaryResolution
        changed
    end

    methods
        function self = ResolutionMatch
            self.primaryResolution = Screen('Resolution', self.primaryScreen);
            self.changed = false;

            screens = Screen('Screens');
            if numel(screens) < 2
                return
            end

            propixxScreen = max(screens);
            propixxResolution = Screen('Resolution', propixxScreen);
            if self.primaryResolution.hz ~= propixxResolution.hz
                Screen('Resolution', self.primaryScreen, self.primaryResolution.width, self.primaryResolution.height, propixxResolution.hz);
                self.changed = true;
            end
        end

        function delete(self)
            if self.changed
                Screen('Resolution', self.primaryScreen, self.primaryResolution.width, self.primaryResolution.height, self.primaryResolution.hz);
            end
        end
    end
end

