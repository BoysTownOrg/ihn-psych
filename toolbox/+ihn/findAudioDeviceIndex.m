function index = findAudioDeviceIndex(name)
wasapi = 13;
devices = PsychPortAudio('GetDevices', wasapi);
device = devices([devices.NrOutputChannels] > 0 & contains(arrayfun(@(d)string(d.DeviceName), devices), name));
if numel(device) ~= 1
    error('Did not find unique audio driver matching name and API.');
end
index = device.DeviceIndex;
end
