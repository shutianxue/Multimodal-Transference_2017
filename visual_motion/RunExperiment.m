%Open windows and run experiment

function RunExperiment(subjectID, trials, prtrials, nconditions, conditions, block)

%Create Data Structure
Data = CreateData(subjectID, nconditions, conditions, block);

%% Define Parameters
fctime = 0.5;     % fixation time, in secs
iti = 0.3;        % inter-stimulus interval, in secs.
stimdur = 0.2;    % stimulus duration, in sec
feedbackT = 0.2;  
correctBeepF = 600;
wrongBeepF = 100;
fs = 48000;       % sample freq in Hz

%% Open window and create colour shortcuts
display.dist = 50;     % view distance, in centimeter
display.width = 37.5;  % in centimeter
display.bgColor = [128 128 128];
white = [255 255 255];
fixcolor=white;

% We need to determine the screen resolution, too.
tmp = Screen('Resolution',0);
display.resolution = [tmp.width,tmp.height];
display = OpenWindow(display);

Screen(display.windowPtr, 'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

%Set font and size
Screen('TextFont',display.windowPtr,'Courier New');
Screen('TextSize',display.windowPtr,50);
linePractice='Press ANY key to start practice.';
lineFormalExp='If you don''t have question,\nPress ANY key to start formal experiment.';

%Get Initial Parameters
[StimValInit, MaxtTest, InitGuess] = GetParams(stimdur);

%Initialize staircases for practice
for j = 1:nconditions
    q(j) = CreateQuest(InitGuess);
end

HideCursor;
KbWait;

%% ------------ Practice ------------
Screen('FillRect', window, display.bgColor);Screen('flip',window);
DrawFormattedText(window,lineFormalExp,200,'center', [1 1 1]);Screen('flip',window);
KbWait;

for prtrial = 1:size(prtrials,1);
    
    %Extract trial parameters
    order = prtrials(prtrial,1);
    condition = prtrials(prtrial,2);
    i = condition;
    
    %Check if first trial
    if size(Data.Practice.PerCondition.StimVals{i}, 1) == 0;
        tTest = log10( StimValInit );
        stimval = StimValInit;
    else
        % Note: Instead of using QuestMedian = QuestQuantile(q(i),0.50)
        % use QuestQuantile with no parameter, which gives "most informative" value to test
                
        tTest = min(MaxtTest,QuestQuantile(q(i)));
        stimvalmost = 10^tTest;
        stimval = 10^tTest;
    end

    % Present fixation
    Screen('FillRect', window, display.bgColor);Screen('flip',window);
    Screen('Drawline',display.windowPtr, fixcolor, display.resolution(1)/2, display.resolution(2)/2-10, display.resolution(1)/2, display.resolution(2)/2+10);
    Screen('Drawline',display.windowPtr, fixcolor, display.resolution(1)/2-10, display.resolution(2)/2, display.resolution(1)/2+10, display.resolution(2)/2);
    Screen('Flip',display.windowPtr);
    WaitSecs(fctime);
        
    % Present Stimuli
    signal = stimval;
    
    if order==0;                                    
        [anstime, answer]=PresentStimulus(signal,90, stimdur,display);    %clockwise
    else                                           
        [anstime, answer]=PresentStimulus(signal, -90, stimdur, display); %counterclockwise
    end

    Screen('FillRect',display.windowPtr,display.bkColor);
    Screen('flip',display.windowPtr);
    WaitSecs(iti);
    
    t0=GetSecs;       
    [answer, anstime]=get_key([37 39], 2, t0);
        
    %Analyze response
    correctness = AnalyzeResponse(order, answer);
        
    %Give feedback
    if correctness == 1
        PlayBeep(correctBeepF,feedbackT,fs) 
    else
        PlayBeep(wrongBeepF,feedbackT,fs)
    end
        
    anstime=anstime-t0;                         
    Screen('FillRect',display.windowPtr,display.bkColor);         %Clear screen
    Screen('flip',display.windowPtr);
        
    WaitSecs(iti);                            
        
    %Update Staircase Structure
    q(i) = QuestUpdate(q(i),tTest,correctness);
    
    %Update Practice Data
    Data.Practice.PerCondition.StimVals{condition} = [Data.Practice.PerCondition.StimVals{condition}; stimval];
end   
    
%Get initial test values from practice trials
for a = 1:Data.Nthresholds
    b = conditions(a);
    prtTest = min(MaxtTest,QuestQuantile(q(b)));     % max tTest = 4 (since max stimval = 10000)
    Data.InitialTest(b) = 10^prtTest;
end

clear Data.Practice

%Reset staircases
clear q
for j = 1:nconditions
    q(j) = CreateQuest(InitGuess);
end

%% ------------ Formal Exp  ------------
Screen('FillRect', window, display.bgColor);Screen('flip',window);
DrawFormattedText(window,linePractice,200,'center', [1 1 1]);Screen('flip',window);
KbWait;

%Run trials
T=size(trials,1);
% Just for testing: T=10;
for trial=1:T
    
    %Extract trial parameters
    order = trials(trial,1);
    condition = trials(trial,2);
    i = condition;
    
    %Check if first experimental trial -- use InitialTest value from practice trials
    if size(Data.Data.PerCondition.StimVals{i}, 1) == 0;
        tTest = log10( Data.InitialTest(i) );
        stimval = 10^tTest;
    else
        % Note: Instead of using QuestMedian = QuestQuantile(q(i),0.50)
        % use QuestQuantile with no parameter, which gives "most informative" value to test
                
        tTest = min(MaxtTest,QuestQuantile(q(i)));     % max tTest = 4 (since max stimval = 10000)
        stimvalmost = 10^tTest;
        stimval = 10^tTest;
    end
            
    % Present fixation
    Screen('FillRect', window, display.bgColor);Screen('flip',window);
    Screen('Drawline',display.windowPtr, fixcolor, display.resolution(1)/2, display.resolution(2)/2-10, display.resolution(1)/2, display.resolution(2)/2+10);
    Screen('Drawline',display.windowPtr, fixcolor, display.resolution(1)/2-10, display.resolution(2)/2, display.resolution(1)/2+10, display.resolution(2)/2);
    Screen('Flip',display.windowPtr);
    WaitSecs(fctime);

    %Stimuli
    signal = stimval;
    
    if order==0;                                    
        [anstime, answer]=PresentStimulus(signal, 90, stimdur, display); %clockwise
    else                                           
        [anstime, answer]=PresentStimulus(signal, -90, stimdur, display); %counterclockwise
    end

    Screen('FillRect',display.windowPtr,display.bkColor);
    Screen('flip',display.windowPtr);
    
    %Prompt and get response
    %disp_text(display.windowPtr,text,colour.white,display.bkColor);  %Display prompt
    %screen('flip',display.windowPtr);
    t0=GetSecs;                                     %Start timer
    [answer, anstime]=get_key([37 39], 2, t0);      % wait for left or right arrow to be pressed
        
    %Analyze response
    correctness = AnalyzeResponse(order, answer);

    %Give feedback
    if correctness == 1
        PlayBeep(correctBeepF,feedbackT,fs)
    else
        PlayBeep(wrongBeepF,feedbackT,fs)
    end
        
    anstime=anstime-t0;                         
    Screen('FillRect',display.windowPtr,display.bkColor);         %Clear screen
    Screen('flip',display.windowPtr);
        
    WaitSecs(iti);                         
        
    %Update Staircase Structure

    q(i) = QuestUpdate(q(i),tTest,correctness);
        
    %Update Data structure
	Data = UpdateData(Data, stimval, correctness, anstime, condition, order);  
end

Screen('CloseAll')
clc

%% Get thresholds and print
fprintf('\n');
for m = 1:Data.Nthresholds
    i = conditions(m);
    t = min(MaxtTest, QuestMean(q(i))); %in case at floor
    Data.Threshold(i) = 10^t;
    fprintf('Threshold Estimate = %7.3f  (%s)\n', Data.Threshold(i), char(Data.ThresholdName(i)));
    Data.ThresholdConfidenceInterval(i,1) = max(0, 10^QuestQuantile(q(i),0.025));
    Data.ThresholdConfidenceInterval(i,2) = min(10^MaxtTest, 10^QuestQuantile(q(i),0.975));
    fprintf('95%% Confidence Interval (%7.4f, %7.3f)\n', ...
        Data.ThresholdConfidenceInterval(i,1), Data.ThresholdConfidenceInterval(i,2));
end
fprintf('\n');


%% Save Data
CreateDataFile(Data)

%% Plot Data
smb{1} = '-*k';
smb{2} = '-*b';
smb{3} = '-*r';
smb{4} = '-*m';
lgdmtrx = [];

figure, hold on
for m = 1:Data.Nthresholds
    i = conditions(m);
    plot((1:size(Data.Data.PerCondition.StimVals{i},1))', Data.Data.PerCondition.StimVals{i}, smb{i});
    lgdmtrx = [lgdmtrx; Data.ThresholdName(i)];
end
legend(lgdmtrx);
xlabel('Trial');
ylabel('Signal (%)');


ShowCursor;