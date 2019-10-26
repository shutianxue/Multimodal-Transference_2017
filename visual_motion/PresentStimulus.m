function [answer, anstime] = PresentStimulus(signal, signaldirection, leng, display)

%% Inputs
% signal is given in proportion -- this represents the coherence of the stimulus.
% signaldirection is given in degrees, clockwise from vertical up

signal = signal/100;

%% Initialize these variables so if we leave the function without an answer it won't complain
anstime=0;
answer=0;

%Is a response required during the display?
if leng==0;                             %Then yes
    waitkey=1;                          %Set flag for later
    leng=timeout;                       %length of display = 60 s
else
    waitkey=0;
end;                             


rand('state',sum(100*clock));           %Initialise the random generator
fr=1;                                       %Initialize to frame 1
t0=GetSecs;                                 %Start timer
tw=0;


%%
% Positions defined in 'real world' coordinates, where (0,0) is
% the center of the screen, positve values of y are in the upper half of
% the screen, and the units will be in degrees of visual angle.

stimdur = leng;
dots.nDots = 78;                % number of dots
dots.color1 = [255,255,255];    % color of the dots
dots.color2 = [0, 0, 0];

%compute dotsize;
dotsang = 0.15; %deg
dots.size = angle2pix(display, dotsang); % size of dots (pixels)
dots.center = [0,0];           % center of the field of dots (x,y)
dots.apertureSize = [7,7];     % size of rectangular aperture [w,h] in degrees.

annulus.size = [14, 14]; %from the center
annulus.nDots = 230;
annulus.x = (rand(1,annulus.nDots)-.5)*annulus.size(1) + dots.center(1);
annulus.y = (rand(1,annulus.nDots)-.5)*annulus.size(2) + dots.center(2);

%%
% Define a random position within the aperture for each of the
% dots.  'dots.x' and 'dots.y'will hold the x and y positions for each
% dot.

dots.x = (rand(1,dots.nDots)-.5)*dots.apertureSize(1) + dots.center(1);
dots.y = (rand(1,dots.nDots)-.5)*dots.apertureSize(2) + dots.center(2);

%%
%
% Define timing and motion parameters,
% which we'll append to the 'dots' structure:

dots.speed = 3.5;       %degrees/second
dots.duration = stimdur;    %seconds
dots.signaldirection = signaldirection;
dots.coherence = signal;    %proportion correlated dots

ncoherentdots = round(dots.nDots*dots.coherence);

if ncoherentdots > 0 
    for k = 1:ncoherentdots
        dots.direction(k) = dots.signaldirection;
    end
end
    
if ncoherentdots ~= dots.nDots
    for j = (ncoherentdots+1):dots.nDots

        dots.direction(j) = round(rand*360);
    end
end


%% Limited Lifetime Dots
dots.lifetime = 120;  %lifetime of each dot (frames)        %in this version, lifetime is not used
annulus.lifetime = 120;                                     %in this version, lifetime is not used

% First we'll calculate the left, right top and bottom of the square aperture (in
% degrees) %%central target only
l = dots.center(1)-dots.apertureSize(1)/2;
r = dots.center(1)+dots.apertureSize(1)/2;
b = dots.center(2)-dots.apertureSize(2)/2;
t = dots.center(2)+dots.apertureSize(2)/2;


% New random starting positions
dots.x = (rand(1,dots.nDots)-.5)*dots.apertureSize(1) + dots.center(1);
dots.y = (rand(1,dots.nDots)-.5)*dots.apertureSize(2) + dots.center(2);

% New random starting pos for annulus dots
annulus.x = (rand(1,annulus.nDots)-.5)*annulus.size(1) + dots.center(1);
annulus.y = (rand(1,annulus.nDots)-.5)*annulus.size(2) + dots.center(2);

% Each dot will have a integer value 'life' which is how many frames the
% dot has been going.  The starting 'life' of each dot will be a random
% number between 0 and dots.lifetime-1 so that they don't all 'die' on the
% same frame:

dots.life(1:50) = 1; %lifetime knocked out.

%dots.life(1:dots.nDots) = 1;
annulus.life = ceil(rand(1,annulus.nDots)*annulus.lifetime); %for later -- static dots for now

for j = 1:dots.nDots
    dx(j) = dots.speed*sin(dots.direction(j)*pi/180)/display.frameRate;
    dy(j) = -dots.speed*cos(dots.direction(j)*pi/180)/display.frameRate;
end
nFrames = secs2frames(display,dots.duration);


%% Set annulus dot positions for this trial
for n = 1:annulus.nDots
    
    if (((annulus.x(n)-dots.center(1)).^2/(annulus.size(1)/2)^2 + (annulus.y(n)-dots.center(2)).^2/(annulus.size(2)/2)^2) >= 1)  ||  (((annulus.x(n)-dots.center(1)).^2/(dots.apertureSize(1)/2)^2 + (annulus.y(n)-dots.center(2)).^2/(dots.apertureSize(2)/2)^2) < 1);
        
        flag1 = 1;
    else
        flag1 = 0;
    end
    
    while(flag1)
        annulus.x(n) = (rand(1,1)-.5)*annulus.size(1) + dots.center(1);
        annulus.y(n) = (rand(1,1)-.5)*annulus.size(2) + dots.center(2);
        if (((annulus.x(n)-dots.center(1)).^2/(annulus.size(1)/2)^2 + (annulus.y(n)-dots.center(2)).^2/(annulus.size(2)/2)^2) >= 1)  ||  (((annulus.x(n)-dots.center(1)).^2/(dots.apertureSize(1)/2)^2 + (annulus.y(n)-dots.center(2)).^2/(dots.apertureSize(2)/2)^2) < 1);
            flag1 = 1;
        else
            flag1 = 0;
        end
    end
end
        

%% present stimulus
%while tw < leng     

    for i=1:nFrames
        
        %update the dot position
        dots.x = dots.x + dx;
        dots.y = dots.y + dy;

        %move the dots that are outside the aperture back rand*one aperture
        %width.
        dots.x(dots.x<l) = dots.x(dots.x<l) + rand*dots.apertureSize(1);
        dots.x(dots.x>r) = dots.x(dots.x>r) - rand*dots.apertureSize(1);
        dots.y(dots.y<b) = dots.y(dots.y<b) + rand*dots.apertureSize(2);
        dots.y(dots.y>t) = dots.y(dots.y>t) - rand*dots.apertureSize(2);
        
        %check that all central target dots fall within ellipse
        for n = 1:dots.nDots
            if ((dots.x(n)-dots.center(1)).^2/(dots.apertureSize(1)/2)^2 + (dots.y(n)-dots.center(2)).^2/(dots.apertureSize(2)/2)^2) >= 1;
                flag2 = 1;
            else
                flag2 = 0;
            end
            
            while(flag2);
            
                dots.x(n) = (rand(1,1)-.5)*dots.apertureSize(1) + dots.center(1);
                dots.y(n) = (rand(1,1)-.5)*dots.apertureSize(2) + dots.center(2);
                if ((dots.x(n)-dots.center(1)).^2/(dots.apertureSize(1)/2)^2 + (dots.y(n)-dots.center(2)).^2/(dots.apertureSize(2)/2)^2) >= 1;
                    flag2 = 1;
                else
                    flag2 = 0;
                end
            end
        end       
        
        %Use the equation of an ellipse to determine which dots fall
        %inside.%just in case
        goodDots = (dots.x-dots.center(1)).^2/(dots.apertureSize(1)/2)^2 + ...
        (dots.y-dots.center(2)).^2/(dots.apertureSize(2)/2)^2 <= 1;

        %goodDotsAnn = (annulus.x-dots.center(1)).^2/(dots.apertureSize(1)/2)^2 + ...
        %(annulus.y-dots.center(2)).^2/(dots.apertureSize(2)/2)^2 > 1;
    
        %sum(goodDots)        
        
        %convert to pixels
        pixpos.x = angle2pix(display,dots.x)+ display.resolution(1)/2;
        pixpos.y = angle2pix(display,dots.y)+ display.resolution(2)/2;
        
        
        pixposann.x = angle2pix(display,annulus.x)+ display.resolution(1)/2;
        pixposann.y = angle2pix(display,annulus.y)+ display.resolution(2)/2;
        
        
        xdat = pixpos.x(goodDots);
        ydat = pixpos.y(goodDots);
        
        %xdatann = pixposann.x(goodDotsAnn);
        %ydatann = pixposann.y(goodDotsAnn);
        
        xdatann = pixposann.x;
        ydatann = pixposann.y;
        
        halfdots = round(length(xdat)/2);
        halfdotsann = round(length(pixposann.x)/2);
        
        Screen('DrawDots',display.windowPtr,[xdat(1:halfdots); ydat(1:halfdots)], dots.size, dots.color1 ,[0,0],1);
        Screen('DrawDots',display.windowPtr,[xdat((halfdots+1):length(xdat)); ydat((halfdots+1):length(xdat))], dots.size, dots.color1 ,[0,0],1);
    
        %Screen('DrawDots',display.windowPtr,[xdatann(1:halfdotsann); ydatann(1:halfdotsann)], dots.size, dots.color1 ,[0,0],1);
        %Screen('DrawDots',display.windowPtr,[xdatann((halfdotsann+1):length(xdatann)); ydatann((halfdotsann+1):length(xdatann))], dots.size, dots.color2 ,[0,0],1);
        
        Screen('Flip',display.windowPtr);
        %increment the 'life' of each dot
        dots.life = dots.life+1;

        %find the 'dead' dots
        deadDots = mod(dots.life,dots.lifetime)==0;

        %replace the positions of the dead dots to a random location on the
        %next frame
        
        dots.x(deadDots) = (rand(1,sum(deadDots))-.5)*dots.apertureSize(1) + dots.center(1);
        dots.y(deadDots) = (rand(1,sum(deadDots))-.5)*dots.apertureSize(2) + dots.center(2);

        
        
        %Mid-display response
        if waitkey==1;
            [answer, anstime]=get_key([37 39], 0);
            if answer > 0;
                anstime=anstime-t0;
                return
            end;
        end;
    
        %Cancel display on Esc
        [k, t, c] = KbCheck;
        esc=find(c);
        if any(esc==27)
            Screen('CloseAll')
            error('Display halted by ESC key')
        end

        tw=GetSecs-t0;                          %Update time
        fr=fr+1;                                %Next frame
        %{
        if i == 1
        imageArray=Screen('GetImage', display.windowPtr, []);
        save imageArray imageArray
        
        newimage = imresize(imageArray, 3);
        imwrite(newimage,'stimulusim.jpg','jpg', 'Quality', 100)
        return
        end
        %}
        
    end

tf=GetSecs;  
%%