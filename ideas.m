classdef VisualTask < handle
    properties (Access = private)
        windowPtr
        visuals
        pre
        mid
        post
        trigger
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
            self.visuals = struct(['draw', {}, 'seconds', {}, 'trigger', {}]);
            self.pre = struct([]);
            self.mid = struct([]);
            self.post = struct([]);
        end

        function addToTrial(self, varargin)
            self.visuals(end+1) = self.makeVisual(varargin{:});
        end

        function before(self, varargin)
            self.pre = self.makeVisual(varargin{:});
        end

        function middle(self, varargin)
            self.mid = self.makeVisual(varargin{:});
        end

        function after(self, varargin)
            self.post = self.makeVisual(varargin{:});
        end

        function run(self, trials)
            ihn.runHighPriorityTask(@self.trialFunction, trials, ...
                'preFunction', @self.preFunction, ...
                'halfwayFunction', @self.halfwayFunction, ...
                'postFunction', @self.postFunction);
        end
    end

    methods (Access = private)
        function visual = makeVisual(self, draw, seconds, trigger)
            if nargin < 4
                trigger = @(~)NaN;
            end
            if ~isa(trigger, 'function_handle')
                trigger = @(~)trigger;
            end
            if ~isa(seconds, 'function_handle')
                seconds = @(~)seconds;
            end
            visual = struct(...
                'draw', draw,...
                'seconds', seconds,...
                'trigger', trigger);
        end

        function flip(self)
            halfFrameSeconds = 0.5/self.frameRateHz;
            self.vbl = Screen('Flip', self.windowPtr, self.vbl + self.seconds - halfFrameSeconds);
        end

        function trialFunction(self, trial)
            for visual = self.visuals
                self.runVisual(visual, trial);
            end
        end

        function preFunction(self)
            self.runVisual(self.pre, []);
        end
 
        function halfwayFunction(self)
            self.runVisual(self.mid, []);
        end

        function postFunction(self)
            self.runVisual(self.post, []);
            self.flip;
        end

        function runVisual(self, visual, data)
            if ~isempty(visual)
                visual.draw();
                self.flip;
                code = visual.trigger(data);
                if ~isnan(code)
                    self.trigger.write(code);
                end
                self.seconds = visual.seconds(data);
            end
        end
    end
end
