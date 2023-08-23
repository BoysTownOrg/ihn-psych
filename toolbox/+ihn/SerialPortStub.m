classdef SerialPortStub < handle
    properties
        written
    end

    methods
        function write(self, data)
            self.written = data;
        end
    end
end