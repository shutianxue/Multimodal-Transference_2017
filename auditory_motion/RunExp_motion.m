
function RunExp_motion(subjectID,block,training,trials, trialsPr, nconditions, conditions)

Screen('Preference', 'SkipSyncTests', 1);
%% ============ Parameters ===============
PsychDefaultSetup(2);screenNumber=max(Screen('Screens'));
HideCursor(screenNumber);
white = WhiteIndex(screenNumber);black = BlackIndex(screenNumber);
[window] = PsychImaging('OpenWindow', screenNumber, white);

Screen('TextSize', window, 45); 
line_practice='Press any key to start practice.';
line_exp='Press any key to start experiment.';
line_question='Where did most beeps go to?';
line_posiFeed='Correct';
line_negaFeed='Wrong';
line_rest='You can have a rest.\n\nPress any key to continue.';
line_ending='This is the end of experiment.\n\nThank you for your participation!';

PauseT    = 0.5;  
feedbackT = 0.5;    % duration of feedback presentation, in secs.
beepT     = 0.1;      % duration of each beep, in secs

%% ============ Staircase setup ============
Data = CreateData(subjectID,block,nconditions,conditions,beepT);

%Get Initial Parameters
[~, MaxtTest, InitGuess] = GetParams;

%Initialize staircases for practice (2 staircases)
for j = 1:nconditions
    q(j) = CreateQuest(InitGuess);
end
    
% Wait for keypress to start
Screen('FillRect', window, [0 0 0]);Screen('flip',window);
DrawFormattedText(window,line_practice,'center','center', [1 1 1]);Screen('flip',window);
KbWait;
Screen('FillRect', window, [0 0 0]);Screen('flip',window);

%% ======= Run practice trials =======
TrialNPrac = size(trialsPr,1);
% just for testing: TrialNPrac=3;
for p = 1:TrialNPrac
    % Extract trial parameters
    order = trialsPr(p,1); 
    condition = trialsPr(p,2); % which staircase is used (1 or 2)
    signalDirection=order;     % direction of signal (-1 or 1)
    
    % Get Initial Parameters
    [StimValInit, MaxtTest, InitGuess] = GetParams;
    
    %Check if first trial
    if size(Data.Practice.PerCondition.StimVals{condition}, 1) == 0
        stimval = StimValInit;
        tTest=log10(stimval);
        snr = stimval/(100-stimval);
    else
        tTest = min(MaxtTest,QuestQuantile(q(condition)));
        stimval = 10^tTest;
        snr=stimval/(100-stimval);
    end

    % Present stimulus
    PresentStimulus(snr, signalDirection, beepT);
    
    % Display question
    DrawFormattedText(window,line_question,'center','center',[1 1 1]); 
    Screen('flip',window);
    
    % Analyse response
    t0=GetSecs;
    [answer, anstime] = get_key([37 39], 2, t0);
    correctness = AnalyzeResponse(order, answer);
   
    % Give visual feedback
    if training == 1
            Screen('FillRect', window, [0 0 0]);Screen('flip',window);
        if correctness == 1
           DrawFormattedText(window,line_posiFeed,'center','center',[0 1 0]); 
        else
           DrawFormattedText(window,line_negaFeed,'center','center',[1 0 0]); 
        end
        Screen('flip',window);
        WaitSecs(feedbackT);
    end
    Screen('FillRect', window, [0 0 0]); Screen('flip',window);
    anstime=anstime-t0;
    WaitSecs(PauseT);                            
    
    %Update Staircase Structure
    q(condition) = QuestUpdate(q(condition),tTest,correctness);
    
    %Update Practice Data
    Data.Practice.PerCondition.StimVals{condition} = [Data.Practice.PerCondition.StimVals{condition}; stimval];
end   
    
%% Get initial test values from practice trials
for a = 1:Data.Nthresholds
    b = conditions(a);
    prtTest = min(MaxtTest,QuestQuantile(q(b))); 
    Data.InitialTest(b) = 10^prtTest;
end

clear Data.Practice

% Reset staircases
clear q
for j = 1:nconditions
    q(j) = CreateQuest(InitGuess);
end

%% ===== Run Experimental Trials =====
DrawFormattedText(window,line_exp,'center','center', [1 1 1]);Screen('flip',window);
KbWait;
Screen('FillRect', window, [0 0 0]);Screen('flip',window);
WaitSecs(PauseT);

trialN = size(trials,1);
% just for testing: 
trialN=20;
for trialcount= 1:trialN
    % Extract trial parameters
    order = trials(trialcount,1); 
    condition = trials(trialcount,2); 
    signalDirection=order;

    % Check if first experimental trial -- use InitialTest value from practice trials
    if size(Data.Data.PerCondition.StimVals{condition}, 1) == 0
        stimval = StimValInit;
        stimval=log10(stimval);
        snr = stimval/(100-stimval); 
    else
        % Note: Instead of using QuestMedian = QuestQuantile(q(i),0.50)
        % use QuestQuantile with no parameter, which gives "most informative" value to test
        
        tTest = min(MaxtTest,QuestQuantile(q(condition)));  
        stimval = 10^tTest;    
        snr = stimval/(100-stimval); 
    end

    % check progress and give a rest in the middle of whole block
    if trialcount==trialN/2+1
        DrawFormattedText(window,line_rest,'center','center',[0 1 1]); Screen('flip',window);
        KbWait;
        Screen('FillRect', window, [0 0 0]); Screen('flip',window);
    end
    
    % Present stimulus
    PresentStimulus(snr,signalDirection, beepT);
  
    % Display question
    DrawFormattedText(window,line_question,'center','center',[1 1 1]);Screen('flip',window);

    % Record and analyse response
    t0=GetSecs;
    [answer, anstime] = get_key([37 39], 2, t0);
    correctness = AnalyzeResponse(order, answer);
    
    % Record data
    Record(trialcount,:)=[snr, signalDirection,correctness];
    
    % Give visual feedback
    if training ==1
            Screen('FillRect', window, [0 0 0]);Screen('flip',window);
        if correctness == 1
           DrawFormattedText(window,line_posiFeed,'center','center',[0 1 0]); 
        else
           DrawFormattedText(window,line_negaFeed,'center','center',[1 0 0]); 
        end
        Screen('flip',window);
        WaitSecs(feedbackT);
    end
    Screen('FillRect', window, [0 0 0]); Screen('flip',window);
    anstime=anstime-t0;
    WaitSecs(PauseT);

    % Update Staircase Structure
    q(condition) = QuestUpdate(q(condition),tTest,correctness);

    % Update Data structure
    Data = UpdateData(Data, snr, correctness, anstime, condition, signalDirection);  
   
end

Data.stimuli_record=Record;

%% Ending
DrawFormattedText(window,line_ending,'center','center',[0 1 1]);Screen('flip',window);
WaitSecs(1.5);
Screen('CloseAll');
clc;

%% Get thresholds and print
fprintf('\n');
for m = 1:Data.Nthresholds %=2
    i = conditions(m);
    t = min(MaxtTest, QuestMean(q(i))); 
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
ShowCursor;