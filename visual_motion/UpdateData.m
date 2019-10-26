function Data = UpdateData(Data, used_stimval, response, anstime, condition, order)

s = condition;

Data.Data.PerCondition.StimVals{s} = [Data.Data.PerCondition.StimVals{s}; used_stimval];
Data.Data.PerCondition.Responses{s} = [Data.Data.PerCondition.Responses{s}; response];
Data.Data.PerCondition.Orders{s} = [Data.Data.PerCondition.Orders{s}; order];
Data.Data.PerCondition.RTs{s} = [Data.Data.PerCondition.RTs{s}; anstime];
    
Data.Data.Running.Condition = [Data.Data.Running.Condition; s];
Data.Data.Running.StimVals = [Data.Data.Running.StimVals; used_stimval];
Data.Data.Running.Responses = [Data.Data.Running.Responses; response];
Data.Data.Running.Orders = [Data.Data.Running.Orders; order];
Data.Data.Running.RTs = [Data.Data.Running.RTs; anstime];
