function noiseRecordPerTrial=PresentStimulus(tarPercent,signalDirection,beepN, beepT)

%% Inputs
% ratio: indicate the proportion of targets in one trial
% signalDirection: rabdomly chosen direction of target (extreme left or right)
% trial: indicate which trial is in process

%% ======= Parameters =======
fs=48000;          % sample rate of beeps
beepFrequency=600; % frequency of beeps

%% Target signals (elevation = 0, azimuth =0/180)
targetN=round(tarPercent*beepN);       % No. of target beeps in one trial
signalAzimuth=repmat(-90*1^(1-signalDirection),1,targetN);

%% Noise signals(elevation = 0, random azimuth (0-180))
noiseN = beepN-targetN;

if tarPercent <0.5 % when noise takes majority, ensure that they are not located on the side opposite to the order 
    NmaxOppoST=beepN/2; %NmaxOppoST: noise max on opposite side of target
    NOppoST=randperm(NmaxOppoST,1);
    NoiseBoxTarOppo=randperm(90,NOppoST)+(1-signalDirection)*45; % azimuth of noises on the opposite side of target
                                                       % if order == -1, +90;
                                                       % if order == 1, no change
    NoiseBoxTarSame=randperm(90,noiseN-NOppoST)+(signalDirection+1)*45; % azimuth of noises on the same side of target
    noiseAzimuth=[NoiseBoxTarOppo,NoiseBoxTarSame];
else
    noiseAzimuth=randperm(180,noiseN);
end

beepAzimuth=[noiseAzimuth,signalAzimuth];

rng('shuffle'); oneTrialRand=randperm(beepN);
beepAzimuthRand=beepAzimuth(oneTrialRand); 

% record noise (sequence, azimuth)
noiseRecordPerTrial=noiseAzimuth;

%% ======== Play one beep  =======  
for b=1:beepN
    produceBeep(fs,beepFrequency,beepT,beepAzimuthRand(b),0);
    WaitSecs(beepT);
end
