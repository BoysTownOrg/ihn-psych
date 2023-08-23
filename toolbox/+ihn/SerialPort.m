classdef SerialPort < handle
    properties (Access = private)
        port
    end

    methods
        function self = SerialPort(name, baudrate)
            self.port = serialport(name, baudrate);
        end

        function write(self, data)
            write(self.port, data, "uint16");
        end
    end
end