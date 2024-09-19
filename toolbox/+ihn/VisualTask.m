classdef VisualTask < handle
    properties (Access = private)
        windowPtr
        trialVisuals
        preVisual
        midVisual
        postVisual
        trigger
        vbl
        seconds
        frameRateHz
    end

    methods
        function self = VisualTask(windowPtr, trigger)
            if nargin < 2
                trigger = ihn.SerialPortStub;
            end

            self.frameRateHz = Screen('FrameRate', windowPtr);
            self.seconds = 0;
            self.windowPtr = windowPtr;
            self.trialVisuals = struct('draw', {}, 'seconds', {}, 'trigger', {});
            self.trigger = trigger;
        end

        function addToTrial(self, varargin)
            self.trialVisuals(end+1) = self.makeVisual(varargin{:});
        end

        function before(self, draw, varargin)
            self.preVisual = self.makeVisual(@(~)draw(), varargin{:});
        end

        function middle(self, draw, varargin)
            self.midVisual = self.makeVisual(@(~)draw(), varargin{:});
        end

        function after(self, draw, varargin)
            self.postVisual = self.makeVisual(@(~)draw(), varargin{:});
        end

        function run(self, trials)
            self.vbl = Screen('Flip', self.windowPtr);
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
            for visual = self.trialVisuals
                self.runVisual(visual, trial);
            end
        end

        function preFunction(self)
            self.runVisual(self.preVisual, []);
        end
 
        function halfwayFunction(self)
            self.runVisual(self.midVisual, []);
        end

        function postFunction(self)
            self.runVisual(self.postVisual, []);
            self.flip;
        end

        function runVisual(self, visual, data)
            if ~isempty(visual)
                visual.draw(data);
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
