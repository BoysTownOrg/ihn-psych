classdef ScopedHighPriority < handle
    methods
        function obj = ScopedHighPriority
            Priority(1);
        end

        function delete(~)
            Priority(0);
        end
    end
end

