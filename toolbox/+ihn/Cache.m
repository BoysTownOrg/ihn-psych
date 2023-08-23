classdef Cache < handle
    properties (Access = private)
        map
    end

    methods
        function self = Cache(args, f, onUpdate)
            self.map = containers.Map;
            for i = 1:numel(args)
                if ~self.map.isKey(args(i))
                    self.map(char(args(i))) = f(args(i));
                end
                if nargin > 2
                    onUpdate(i);
                end
            end
        end

        function result = at(self, arg)
            result = self.map(char(arg));
        end
    end
end
