function cache = createTextureCache(windowPtr, imageNames, imagePathFromName)
if nargin < 3
    imagePathFromName = @(name)name;
end
cache = ihn.Cache(imageNames, @(name)Screen('MakeTexture', windowPtr, imread(imagePathFromName(name))));
end
