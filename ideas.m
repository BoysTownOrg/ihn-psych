classdef VisualTask < handle
    properties
        windowPtr
        visuals
        vbl
        seconds
        frameRateHz
    end

    methods
        function self = VisualTask(windowPtr)
            self.frameRateHz = Screen('FrameRate', windowPtr);
            self.vbl = Screen('Flip', windowPtr);
            self.seconds = 0;
            self.windowPtr = windowPtr;
        end

        function flip(self)
            halfFrameSeconds = 0.5/self.frameRateHz;
            self.vbl = Screen('Flip', self.windowPtr, self.vbl + self.seconds - halfFrameSeconds);
        end

        function trialFunction(self, trial)
            for visual = self.visuals
                visual.draw(trial);
                self.flip;
                self.trigger.write(visual.code(trial));
                self.seconds = visual.seconds(trial);
            end
        end

        function halfwayFunction(self)
            self.mid.draw;
            self.flip;
            self.seconds = mid.seconds;
        end

        function postFunction(self)
            self.post.draw;
            self.flip;
            self.trigger.write(post.code)
            self.seconds = post.seconds;
            self.flip;
        end
    end
end
