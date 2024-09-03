function WM_ManipulateHeavyRefactor(varargin)
%WM Manipulate

%AUTHOR INFORMATION: Seth Springer. Using Beth's Spatial WM code as a base.

%Version History: V1 03/01/2023

%INPUTS: Participant Number, Practice y or n

%Other notes: The idea in making this code is to try and have three boxes
%that have letters centered in.
%In both conditions, the letters that are used muse be 5-8 letters apart in
%the alphabet.
%The letters are never, in either condition (maintain or manipulate), all three in alphabetical order
%Beth constructed the stim lists. These lists are balanced (across
%condition) for condition order (inset and outset; note that maintain
%versus manipulate are blocked).

%Instructions:



%------------------------------------------------------------------------%
%                            Trigger Legend                              %
%------------------------------------------------------------------------%
%Fixation = 60
%
%Maintain
%Encoding Inset         = 21
%Retrieval Inset        = 31
%Encoding out of set    = 22
%Retrieval out of set   = 32

%Manipulate
%Encoding Inset         = 41
%Retrieval Inset        = 51
%Encoding out of set    = 42
%Retrieval out of set   = 52


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%------------------------------------------------------------------------%
%                             General Setup
%------------------------------------------------------------------------%

% ihn-psych (ihn.*) classes may be loaded into memory from
% a previous task. Since ihn-psych was originally installed
% as a toolbox, different versions of these classes are
% available on the path. We want to ensure MATLAB clears
% all other versions of these classes and re-searches for
% them where the bundled +ihn/ folder, the correct version,
% takes precedence.
% 'clear classes' clears variables in scope, which is undesired.
% 'clear functions' appears to be sufficient.
clear functions %#ok<CLFUNC>

parser = inputParser;
parser.addParameter('triggerFactory', @ihn.BioSemi);
parser.parse(varargin{:});

inputs = {'Participant number/ID', 'Practice (y or n)', 'Maintain or Manipulate?'};
defaults = {'0', 'n', 'Maintain'};	%prompt for experiment parameters, read inputs into variables%
answer = inputdlg(inputs, 'Please input answers', 2, defaults);
if isempty(answer)
    return
end
[PartId,Practice,Condition] = deal(answer{:});

trigger = parser.Results.triggerFactory();

EncDur = 1.5;
MaintDur = 2.5;
RetDur = 1.3;

if strcmp(Practice,'n')
    DefaultName = strcat('WM_Manipulate', '__', PartId, '_', Condition);
    PathName = 'output';
    [success, message] = mkdir(PathName);
    if ~success
        error('Failed to create output directory: %s: %s', PathName, message);
    end
    FileName=strcat(DefaultName,'.xls');
    outputfile = wmm.File(fullfile(PathName,FileName));
    fprintf(outputfile, 'PartId\t TrialNumber\t EncodingTrigger\t Jitter(s)\n');
else
    outputfile = wmm.NullFile;
end

window = ihn.createMEGWindow();
frameRateHz = Screen('FrameRate', window.pointer);
DrawFormattedText(window.pointer, 'Loading...', 'center', 'center', [255, 255, 255]);
Screen('Flip', window.pointer);

%%%%%-Set Color Scheme-%%%%%
black = [0 0 0];
gray = [30 30 30];%set color indices and bgcolor%
bgcolor = black;
textcolor = gray;
fixation_color=[50 50 50];

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(window.rectangle);
center = [window.rectangle(3)/2, window.rectangle(4)/2];	%set screen parameters and important stimulus positions%

%use this value to scale the squares larger or smaller
scaling_factor = .09;

% Make a base Rect of 200 by 200 pixels
dim = window.rectangle(3)*scaling_factor; %was 50
baseRect = [0 0 dim dim];

%%%%%make the three rect positions that are going to be where the letter pictures are placed.

%Center point for all three squares (rows = square positions (left, center, and right), columns = x/y center points)
%These should be positioned just above the fixation cross
position_centers(1,:) = [xCenter-dim, yCenter-(dim/2)]; %shifted left and shifted up
position_centers(2,:) = [xCenter, yCenter-(dim/2)]; %centered in the x-axis, shifted up
position_centers(3,:) = [xCenter+dim, yCenter-(dim/2)]; %shifted right and shifted up

% Make our rectangle coordinates (rows = square positions (left, center, and right), columns = x/y center points)
for i = 1:size(position_centers,1)
    position_coordinates(i,:) = CenterRectOnPointd(baseRect, position_centers(i,1), position_centers(i,2));
end

% Fixation %
fixCrossDimPix = 0.02*window.rectangle(4); %sets the fixation cross arm size (this is a ratio of the window dimensions--3% of the y window dimension)
fixLineCoords = [-fixCrossDimPix fixCrossDimPix 0 0; 0 0 -fixCrossDimPix fixCrossDimPix];   %set fixation stimulus parameters relative to zero based on pixel/ratio size (for the x plane, how many pixels left/right the cross will take up; for the y plane, how many pixels up/down the cross will take up)

% Set the line width for our fixation cross
lineWidthPix = 4;

%-------------------------------------------------------------------------%
%                         Read in task information                        %
%-------------------------------------------------------------------------%
if strcmp(Practice,'n') && strcmp(Condition,'Maintain')
    cond_text = 'Stim_TextFile_Maintain.txt';
    opts = detectImportOptions(cond_text); %setup table import from selected
    cond_table = readtable(cond_text,opts);
elseif strcmp(Practice,'n') && strcmp(Condition,'Manipulate')
    cond_text = 'Stim_TextFile_Manipulate.txt';
    opts = detectImportOptions(cond_text); %setup table import from selected
    cond_table = readtable(cond_text,opts);
elseif strcmp(Practice,'y') && strcmp(Condition,'Maintain')
    cond_text = 'Stim_TextFile_Maintain.txt';
    opts = detectImportOptions(cond_text); %setup table import from selected
    cond_table = readtable(cond_text,opts);

    %Now to make the practice trials, pull some "pseudorandom" trials
    %cond_table = cond_table([15 17 44 51 61 74 8 22 34 36],:);
    cond_table = cond_table([1 2 3 4 5 6 7 8 9 10],:); %temp practice xx
elseif strcmp(Practice,'y') && strcmp(Condition,'Manipulate')
    cond_text = 'Stim_TextFile_Manipulate.txt';
    opts = detectImportOptions(cond_text); %setup table import from selected
    cond_table = readtable(cond_text,opts);

    %Now to make the practice trials, pull some "pseudorandom" trials
    %cond_table = cond_table([15 17 44 51 61 74 8 22 34 36],:);
    cond_table = cond_table([1 2 3 4 5 6 7 8 9 10],:); %temp practice xx
else %this is to catch anything that might have been incorrectly input
    fprintf('\n\n\n\n\n\n')
    error('Please enter "Practice" and "Condition Name" information again (CASE MATTERS)')
end

TrialNum = length(cond_table.Trial);

stim_dir = 'stimuli_tif_smaller';
imageNames = ["B", "Blank", "C", "D", "F", "G", "H", "J", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "X", "Z"];
textureCache = ihn.Cache(imageNames, @(name)Screen('MakeTexture', window.pointer, imread(fullfile(stim_dir, sprintf('%s.tif', name)))));

vbl = Screen('Flip', window.pointer);
ihn.runHighPriorityTask(@runTrial, 1:TrialNum, 'halfwayFunction', @showBreak, 'postFunction', @letUserRespond);

Screen('TextSize', window.pointer, 60);
task = ihn.VisualTask(window.pointer);
task.addToTrial(@fixation, @(i)cond_table.Fixation(i)/1000, 60);
task.addToTrial(@encoding, EncDur, @(i)cond_table.RetTrigger(i));
task.addToTrial(@maintenance, MaintDur);
task.addToTrial(@retrieval, RetDur, @(i)cond_table.RetTrigger(i));
task.middle(@rest, 15);
task.after(@fixation, cond_table.Fixation(1)/1000, 60);
task.run(1:TrialNum);

    function showBreak()
        %Halfway point break
        if strcmp(Practice,'n')
            DrawFormattedText(window.pointer, [...
                'Great Job!\n',...
                'Please remain still and feel free to rest your eyes.\n',...
                'The task will resume in 15 seconds.'...
                ], 'center', 'center', textcolor);
            vbl = Screen('Flip', window.pointer, vbl + RetDur - 0.5/frameRateHz);
            vbl = Screen('Flip', window.pointer, vbl + 15 - 0.5/frameRateHz);
        end
    end

    function rest
        DrawFormattedText(window.pointer, [...
            'Great Job!\n',...
            'Please remain still and feel free to rest your eyes.\n',...
            'The task will resume in 15 seconds.'...
            ], 'center', 'center', textcolor);
    end

    function blanks
        Screen('DrawTextures', window.pointer, textureCache.at('Blank'), [], position_coordinates(1,:))
        Screen('DrawTextures', window.pointer, textureCache.at('Blank'), [], position_coordinates(2,:))
        Screen('DrawTextures', window.pointer, textureCache.at('Blank'), [], position_coordinates(3,:))
        Screen('DrawLines',window.pointer,fixLineCoords,lineWidthPix, fixation_color,center); %fixation cross
    end

    function fixation(~)
        blanks;
    end

    function encoding(i)
        Screen('DrawTextures', window.pointer, textureCache.at(cond_table.Enc1{i}), [], position_coordinates(1,:))
        Screen('DrawTextures', window.pointer, textureCache.at(cond_table.Enc2{i}), [], position_coordinates(2,:))
        Screen('DrawTextures', window.pointer, textureCache.at(cond_table.Enc3{i}), [], position_coordinates(3,:))
        Screen('DrawLines',window.pointer,fixLineCoords,lineWidthPix, fixation_color,center); %fixation cross
    end

    function maintenance
        blanks;
    end

    function retrieval(i)
        Screen('DrawTextures', window.pointer, textureCache.at(maybeBlank(cond_table.Ret1{i})), [], position_coordinates(1,:))
        Screen('DrawTextures', window.pointer, textureCache.at(maybeBlank(cond_table.Ret2{i})), [], position_coordinates(2,:))
        Screen('DrawTextures', window.pointer, textureCache.at(maybeBlank(cond_table.Ret3{i})), [], position_coordinates(3,:))
        Screen('DrawLines',window.pointer,fixLineCoords,lineWidthPix, fixation_color,center); %fixation cross
    end


    function runTrial(i)
        %Fixation
        Screen('DrawTextures', window.pointer, textureCache.at('Blank'), [], position_coordinates(1,:))
        Screen('DrawTextures', window.pointer, textureCache.at('Blank'), [], position_coordinates(2,:))
        Screen('DrawTextures', window.pointer, textureCache.at('Blank'), [], position_coordinates(3,:))
        Screen('DrawLines',window.pointer,fixLineCoords,lineWidthPix, fixation_color,center); %fixation cross
        vbl = Screen('Flip',window.pointer, vbl + RetDur - 0.5/frameRateHz);
        trigger.write(60);

        Screen('DrawTextures', window.pointer, textureCache.at(cond_table.Enc1{i}), [], position_coordinates(1,:))
        Screen('DrawTextures', window.pointer, textureCache.at(cond_table.Enc2{i}), [], position_coordinates(2,:))
        Screen('DrawTextures', window.pointer, textureCache.at(cond_table.Enc3{i}), [], position_coordinates(3,:))
        Screen('DrawLines',window.pointer,fixLineCoords,lineWidthPix, fixation_color,center); %fixation cross
        vbl = Screen('Flip',window.pointer, vbl + cond_table.Fixation(i)/1000 - 0.5/frameRateHz);
        trigger.write(cond_table.EncTrigger(i));

        %Maintenance (all blank figures)
        Screen('DrawTextures', window.pointer, textureCache.at('Blank'), [], position_coordinates(1,:))
        Screen('DrawTextures', window.pointer, textureCache.at('Blank'), [], position_coordinates(2,:))
        Screen('DrawTextures', window.pointer, textureCache.at('Blank'), [], position_coordinates(3,:))
        Screen('DrawLines',window.pointer,fixLineCoords,lineWidthPix, fixation_color,center); %fixation cross
        vbl = Screen('Flip',window.pointer, vbl + EncDur - 0.5/frameRateHz);

        %Retrieval (two blank figures)
        Screen('DrawTextures', window.pointer, textureCache.at(maybeBlank(cond_table.Ret1{i})), [], position_coordinates(1,:))
        Screen('DrawTextures', window.pointer, textureCache.at(maybeBlank(cond_table.Ret2{i})), [], position_coordinates(2,:))
        Screen('DrawTextures', window.pointer, textureCache.at(maybeBlank(cond_table.Ret3{i})), [], position_coordinates(3,:))
        Screen('DrawLines',window.pointer,fixLineCoords,lineWidthPix, fixation_color,center); %fixation cross
        vbl = Screen('Flip',window.pointer, vbl + MaintDur - 0.5/frameRateHz);
        trigger.write(cond_table.RetTrigger(i));

        if strcmp(Practice,'n')
            %before moving to the next trial, write out the info for this trial.
            %This ensures that data is in the run file even if the task is stopped
            %before naturally finishing
            fprintf(outputfile, '%s\t %d\t %d\t %.5f\n', PartId, i, cond_table.EncTrigger(i), cond_table.Fixation(i));
        end
    end

    function letUserRespond()
        %You need to end with one final fixation, to ensure that the participants have enough time to respond to the final trial
        Screen('DrawTextures', window.pointer, textureCache.at('Blank'), [], position_coordinates(1,:))
        Screen('DrawTextures', window.pointer, textureCache.at('Blank'), [], position_coordinates(2,:))
        Screen('DrawTextures', window.pointer, textureCache.at('Blank'), [], position_coordinates(3,:))

        Screen('DrawLines',window.pointer,fixLineCoords,lineWidthPix, fixation_color,center); %fixation cross
        vbl = Screen('Flip',window.pointer, vbl + RetDur - 0.5/frameRateHz);
        trigger.write(60);

        vbl = Screen('Flip', window.pointer, vbl + cond_table.Fixation(1)/1000 - 0.5/frameRateHz);
    end
end

function name = maybeBlank(name)
if isempty(strip(name))
    name = 'Blank';
end
end
