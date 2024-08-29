classdef WritableFile < handle
    properties
        id
    end
    
    methods
        function self = WritableFile(path)
            [self.id, message] = fopen(path, 'w');
            if self.id == -1
                error('Unable to open %s for writing: %s', path, message);
            end
        end

        function varargout = fprintf(self, varargin)
            [varargout{1:nargout}] = fprintf(self.id, varargin{:});
        end
        
        function delete(self)
            fclose(self.id);
        end
    end
end
