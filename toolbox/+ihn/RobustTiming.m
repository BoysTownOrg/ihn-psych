classdef RobustTiming < handle
    properties
        start
        frameRateHz
    end

    methods
        function self = RobustTiming(frameRateHz)
            self.start = GetSecs();
            self.frameRateHz = frameRateHz;
        end

        function onFlip(self)
        end

        function answer = nextFlipWillBeNear(self, ms)
            answer = GetSecs() - self.start >= ms/1000 - 1.5/self.frameRateHz;
        end
    end
end