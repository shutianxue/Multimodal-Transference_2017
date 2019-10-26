function Data = CreateData(subjectID, block,nconditions, conditions,beepT)


%Get screen specifications
Data.SubjectID = subjectID;
Data.block=block;
Data.stimuli_record=[];
Data.StimulusDuration = beepT;
Data.Nthresholds = nconditions;
Data.Conditions = conditions;
Data.ThresholdName = {'';'';'';''};
Data.InitialTest = [];
Data.Threshold = -1*ones(4,1);                          %Create all and hold empty if missing
Data.ThresholdConfidenceInterval = repmat([-1 -1],4,1); %Create all and hold empty if missing

Data.Data.Running.Condition = [];
Data.Data.Running.StimVals = [];
Data.Data.Running.Responses = [];
Data.Data.Running.Orders = [];
Data.Data.Running.RTs = [];

Data.Data.PerCondition.StimVals = [];
Data.Data.PerCondition.Responses = [];
Data.Data.PerCondition.Orders = [];
Data.Data.PerCondition.RTs = [];

%Deleted later
Data.Practice.PerCondition.StimVals = [];

for f = 1:4 %Create all and hold empty if missing
    Data.Data.PerCondition.StimVals{f} = [];
    Data.Data.PerCondition.StimValsDeg{f} = [];
    Data.Data.PerCondition.Responses{f} = [];
    Data.Data.PerCondition.Orders{f} = [];
    Data.Practice.PerCondition.StimVals{f} = [];
    Data.Data.PerCondition.RTs{f} = [];
end