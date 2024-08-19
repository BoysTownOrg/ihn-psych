classdef ScopedHiddenCursor < handle
    properties
        screenNumber
    end

    methods
        function self = ScopedHiddenCursor(screenNumber)
            HideCursor(self.screenNumber);
            self.screenNumber = screenNumber;
        end

        function delete(self)
            ShowCursor([], self.screenNumber);
        end
    end
end

