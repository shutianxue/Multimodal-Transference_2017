function plotData(Data)

smb{1} = '-*k';
smb{2} = '-*b';

figure, hold on
conditions=[1,2];

for m = 1:2 
    i = conditions(m);
    plot((1:size(Data.Data.PerCondition.StimVals{i},1))', Data.Data.PerCondition.StimVals{i}, smb{i});
end
xlabel('TrialCount');
ylabel('SNR');