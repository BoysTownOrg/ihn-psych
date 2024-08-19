classdef Chronos < handle
    properties (Access = private)
        port
    end

    methods
        function self = Chronos
            self.port = serialport("COM1", 19200);
        end

        function write(self, data)
            write(self.port, data, "uint16");
        end
    end
end
