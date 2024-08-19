classdef BioSemi < handle
    properties (Access = private)
        port
    end

    methods
        function self = BioSemi
            self.port = serialport("COM3", 115200);
        end

        function write(self, data)
            write(self.port, data, "uint8");
        end
    end
end
