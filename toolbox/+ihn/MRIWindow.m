classdef MRIWindow < handle
    properties
        pointer
        rectangle
    end

    properties (Access = private)
        hiddenCursor
    end
    
    methods
        function self = MRIWindow(screenNumber, backgroundColor, rect)
            if nargin < 3
                % Default is full screen
                rect = [];
            end
            if nargin < 2
                backgroundColor = [0, 0, 0];
            end
            [self.pointer, self.rectangle] = Screen('OpenWindow', screenNumber, backgroundColor, rect);
            self.hiddenCursor = ihn.ScopedHiddenCursor(screenNumber);
        end
        
        function delete(self)
            Screen('Close', self.pointer);
        end
    end
end
