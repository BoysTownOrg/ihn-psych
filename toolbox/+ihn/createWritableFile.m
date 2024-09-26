function file = createWritableFile(path, overwrite)
if nargin < 2
    overwrite = false;
end
directory = fileparts(path);
[success, message] = mkdir(directory);
if ~success
    error('Failed to create output directory: %s: %s', directory, message);
end
if ~overwrite && exist(path, 'file') ~= 0
    error('File already exists: %s', path);
end

file = ihn.WritableFile(path);
end
