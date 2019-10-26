function quest_Vmotion(subjectID, block)

%% Description

% "Coarse motion task" using stimuli in a center-surround configuration.
% On each trial, observers are required to judge whether the motion in the
% central target is net "left" or net "right".  
% Percentage signal is adjusted according to QUEST.

% Inputs
%       subjectID: three-letter subject identifier
%       viewdist: viewing distance; given in cm
%       scrnvbl: monitor size, diagonal, given in inches 
%               (note, we don't actually use this to compute. Check display.width in RunExperiment!!
%       stimdur: stimulus duration, in sec (set to 0.2)
%       signaldirection: angle offset from vertical for the central target (in deg)
%                        (set to 90)
%       block

% Edits
% DATE           %WHO                %DESCRIPTION
% 2011-02-03      Dorita Chang        Written
% 2011-02-04      Dorita Chang        Updated dot density.  Removed
%                                       saving of q structures
% 2011-03-15      Dorita Chang        Updated get_key to include option of
%                                       max response time (opt. 2).
%                                       Changed fixation time.  Changed
%                                       number of trials.
% 2017-11-03      Shutian Xue         Personalize it



%% Set up trials and Run Expt
%Intervals
order = [0;1];      % intervals/alternatives, keep for other designs
conditions = [1;2]; % which staircase

%Check number of staircases
nconditions = size(conditions,1);

%Number of trials per staircase
numtrials = 60;

ntrials = numtrials/(size(order,1)); %ntrials gives trials per number of alternatives

%Prepare trials
tr = 1;
for r=1:ntrials
    for p=1:size(order,1)
        for q=1:size(conditions,1)
            trials(tr,1)= order(p);
            trials(tr,2)= conditions(q);
            tr=tr+1;
        end
    end
end

random=randperm(size(trials,1));
j=1;
for i=random
    trials2(j,:)=trials(i,:);
    j=j+1;
end
trials=trials2;
clear trials2;


%Create practice trials for experimental block.  These determine initial
%test values of the 60 trials/blck.

numtrialspr = 4;
ntrialspr = numtrialspr/(size(order,1));
tr = 1;
for r=1:ntrialspr
    for p=1:size(order,1)
        for q=1:size(conditions,1)
            trialspr(tr,1)= order(p);
            trialspr(tr,2)= conditions(q);
            tr=tr+1;
        end
    end
end

random=randperm(size(trialspr,1));
j=1;
for i=random
    trialspr2(j,:)=trialspr(i,:);
    j=j+1;
end
prtrials=trialspr2;
clear trialspr2;

%Run Experiment
RunExperiment(subjectID, trials, prtrials, nconditions, conditions, block)
