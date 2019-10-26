function QUEST_motion(subjectID, block)

% ----------- Description -----------
% "Auditory motion task" 
% On each trial, observers are presented with a strain of moving beeps (varying in moving direction % SNR, signal-noise ratio
% Subjects are required to judge whether the sound goes to left or right. 
% SNR is signal vs. noise ratio in magnitude (dB), which is adjusted according to QUEST.

% ----------- Inputs -----------
% subjectID       three-letter subject identifier
% block          


%% Direction and staricase
order = [-1;1];                    % left or right (-1:left; 1:right)
norders= size(order,1);            % Number of order

conditions = [1;2];                % Which staircase (1;2)
nconditions = size(conditions,1);  % Number of staircases

%% Prepare practice trials
% Number of trials per staircase
numTrialsPr = 2; % makes 4 practices in total
ntrialsPr = numTrialsPr/norders; 

trialsPr=[];
trialRow = 1;
for r=1:ntrialsPr
    for p=1:norders 
        for q=1:nconditions 
            trialsPr(trialRow,1)= order(p);
            trialsPr(trialRow,2)= conditions(q);
            trialRow=trialRow+1;
        end
    end
end % 

% randomize [trials] 
random=randperm(size(trialsPr,1));
j=1;
for i=random
    trialsPr2(j,:)=trialsPr(i,:);
    j=j+1;
end
trialsPr=trialsPr2;
clear trialsPr2;

%% Prepare formal experiment trials
numTrials = 60;                    % Number of trials per staircase
ntrials = numTrials/norders;

trialRow = 1;
for r = 1:ntrials
    for p = 1:norders
        for q = 1:nconditions 
            trials(trialRow,1)= order(p);
            trials(trialRow,2)= conditions(q);
            trialRow=trialRow+1;
        end
    end
end      % column 1: order (-1 or 1); 
         % column 2: condition (1 or 2)

% randomize [trials]
random=randperm(size(trials,1));
j=1;
for i=random
    trials2(j,:)=trials(i,:);
    j=j+1;
end
trials=trials2;
clear trials2;


% Run Experiment
RunExp_motion(subjectID,block,trials, trialsPr, nconditions, conditions)
