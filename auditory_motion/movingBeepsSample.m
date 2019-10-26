function movingBeepsSample

beepT=0.1;
% produce moving beeps (signla + Gaussian white noise)

fs=48000;
beepN=100;          % number of beeps in one trial (signal+noise)  
beepFrequency=600;  % frequency of beeps

%% Produce Hann window
%hannWindow = hann(fs*beepT);
%hannWindow=hannWindow';

%% Signals
% Standard sound 
beepStandard_o=sin(linspace(0, beepT * beepFrequency * 2*pi,round(beepT * fs)));
beepStandard=beepStandard_o.*hannWindow; % add Hann window to smooth out the sound

% Signals
delta=linspace(1,0.5,beepN); % set level difference between beeps in two channels
signalLower=[];
for j=1:beepN
    signalLower(j,:)=real(ifft(fft(beepStandard)*delta(j)));
end

%% Play Sound
% beeps go to left
tic;
for trialCount=1:beepN
    sound([beepStandard;signalLower(trialCount,:)],fs);
end
toc;
WaitSecs(1);

tic;
% sound go to right
for trialCount=1:beepN
    sound([signalLower(trialCount,:);beepStandard],fs);
end
toc;

