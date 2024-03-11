classdef PreciseTiming < handle
    properties
        frameCount
        frameRateHz
    end

    methods
        function self = PreciseTiming(frameRateHz)
            self.frameCount = 0;
            self.frameRateHz = frameRateHz;
        end

        function onFlip(self)
            self.frameCount = self.frameCount + 1;
        end

        function answer = nextFlipWillBeNear(self, ms)
            answer = self.frameCount + 1 >= self.frameRateHz * ms / 1000;
        end
    end
end