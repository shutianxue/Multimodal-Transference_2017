function noiseRecordPerTrial=PresentStimulus(tarPercent,signalDirection,beepN, beepT,elevation)

%% Inputs
%       ratio: indicate the proportion of targets in one trial
%       signalDirection: -1 = left (azimuth = -90); 1= extreme right (azimuth=90)
%       trial: which trial is in process

%% ======= Parameters =======
fs=48000;          % sample rate of beeps
beepFrequency=600; % frequency of beeps

%% Target beeps
targetN=round(tarPercent*beepN);       % No. of target beeps in one trial
miu=90; % mean of distribution of target signals (azimuth)
SD=3;   % standard deviation of distribution of target signals (azimuth)
signalAzimuthBox=[];
flag=0;
for n=1:targetN
    while flag==0
        rng ('shuffle');
        signalAzimuth=(abs(SD*randn(1)+miu))*signalDirection;
        if abs(signalAzimuth)<=90
            flag=1;
        end
    end
    flag=0;
    signalAzimuthBox(n)=signalAzimuth;
end

%% Noise beeps
noiseN = beepN-targetN;
miu=0; % mean of distribution of target signals (azimuth)
SD=40; % standard deviation of distribution of target signals (azimuth)

% when noise takes majority, ensure that they are not located on the side opposite to the order 
if tarPercent <0.5 
    NmaxOppoST=round(beepN/2)-1; % max number of noise beeps that are located on opposite side of target
    NOppoST=randperm(NmaxOppoST,1);  % number of noise beeps that are located on opposite side of target
   
    % azimuth of noises on the opposite side of target
    NoiseTarOppoBox=[];
    for n=1:NOppoST
        rng ('shuffle');
        NoiseTarOppo=(abs(SD*randn(1)+miu))*signalDirection*(-1);
        NoiseTarOppoBox(n)=NoiseTarOppo;
    end
    % azimuth of noises on the same side of target
    NoiseTarSameBox=[];
    for n=1:noiseN-NOppoST
        rng ('shuffle');
        NoiseTarSame=(abs(SD*randn(1)+miu))*signalDirection;
        NoiseTarSameBox(n)=NoiseTarSame;
    end
    noiseAzimuthBox=[NoiseTarOppoBox,NoiseTarSameBox];
else
    noiseAzimuthBox=[];
    for n=1:noiseN
        rng ('shuffle');
        noiseAzimuth=(abs(SD*randn(1)+miu))*signalDirection;
        noiseAzimuthBox(n)=noiseAzimuth;
    end
end

% combine and randomize
beepAzimuth=[noiseAzimuthBox,signalAzimuthBox];
rng('shuffle'); oneTrialRand=randperm(beepN);
beepAzimuthRand=beepAzimuth(oneTrialRand); 

% record noise (sequence, azimuth)
noiseRecordPerTrial=noiseAzimuthBox;

%% ======== Play one beep  =======  
for b=1:beepN
    produceBeep(fs,beepFrequency,beepT,beepAzimuthRand(b),elevation);
    WaitSecs(beepT);
end
