function disp_text(window, text, textcolour, backcolour, rect)

%disp_text(window, text, textcolour, backcolour, rect)
%
%Displays a line of text centred within boundaries 'rect' (e.g. [0 0 1024 768] for the whole screen) 
%If rect is not input, default is the whole screen
%
%INPUTS
%window             display window pointer
%text               text string to display
%textcolour         RGB index or single colour shortcut (.e.g colour.black - not the whole colour shortcut structure!)
%backcolour         background colour
%rect               OPTIONAL: rectangle within which text is centred
%                   else set to whole screen

%INTERNAL
%normboundsrect     rectangle approximately bounding text if it were to be displayed at 0,0 - element 3 gives width of 
%                   text and element 4 gives height (pixels)
%xcenter            centre coords for text display area
%ycenter


%Setup boundary defaults
if ~exist('rect', 'var')
    rect=screen('Rect',0);            % Window-coordinates, e.g. [0 0 1024 768]
end

%Get centre of writing area
xcenter=round((rect(1)+rect(3))/2);
ycenter=round((rect(2)+rect(4))/2);

%Measure text size
[normboundsrect, offsetboundsrect]=Screen('TextBounds', window, text);

%DRAW TEXT
screen('fillrect',window, backcolour, rect);                                                                %Background colour
screen('DrawText', window, text, xcenter-normboundsrect(3)/2, ycenter-0.75*normboundsrect(4), textcolour);  %Text
%Note: the y normboundsrect doesn't quite work properly - 0.75 above is a scaling factor that has been found to work
%for vertical centring