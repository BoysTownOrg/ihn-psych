classdef Window < handle
    properties
        pointer
        rectangle
    end

    properties (Access = private)
        hiddenCursor
        resolutionMatch
    end
    
    methods
        function self = Window(screenNumber, backgroundColor, rect)
            if nargin < 3
                % Default is full screen
                rect = [];
            end
            if nargin < 2
                backgroundColor = [0, 0, 0];
            end
            % The resolution can only be changed before any on screen windows
            % are opened.
            self.resolutionMatch = ihn.ResolutionMatch;
            [self.pointer, self.rectangle] = Screen('OpenWindow', screenNumber, backgroundColor, rect);
            self.hiddenCursor = ihn.ScopedHiddenCursor(screenNumber);
        end
        
        function delete(self)
            Screen('Close', self.pointer);
        end
    end
end
