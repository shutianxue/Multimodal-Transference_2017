function Data = UpdateData(Data, snr, correctness, anstime, condition, signalDirection)

s = condition;

Data.Data.PerCondition.StimVals{s} = [Data.Data.PerCondition.StimVals{s}; snr];
Data.Data.PerCondition.Responses{s} = [Data.Data.PerCondition.Responses{s}; correctness];
Data.Data.PerCondition.Orders{s} = [Data.Data.PerCondition.Orders{s}; signalDirection];
Data.Data.PerCondition.RTs{s} = [Data.Data.PerCondition.RTs{s}; anstime];
    
Data.Data.Running.Condition = [Data.Data.Running.Condition;s];
Data.Data.Running.StimVals = [Data.Data.Running.StimVals; snr];
Data.Data.Running.Responses = [Data.Data.Running.Responses; correctness];
Data.Data.Running.Orders = [Data.Data.Running.Orders; signalDirection];
Data.Data.Running.RTs = [Data.Data.Running.RTs; anstime];
