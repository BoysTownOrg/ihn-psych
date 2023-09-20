function package(version, outputPath)
uuid = "boystown-ihn-psych";
toolboxFolder = "toolbox";
opts = matlab.addons.toolbox.ToolboxOptions(toolboxFolder, uuid);
opts.ToolboxName = "IHN Psych";
opts.OutputFile = outputPath;
opts.ToolboxVersion = version;
opts.AuthorName = "Boys Town";
opts.AuthorCompany = "Boys Town";
matlab.addons.toolbox.packageToolbox(opts);
end
