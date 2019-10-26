function PresentStimulus(snr, signalDirection, beepT)

% this script produces moving beeps (signal + Gaussian white noise)
 
fs=48000;
beepN=150;          % number of beeps in one trial 
% beepT does not seem to be linearly correlated with trial duration (might due to Hann window)
% So we can control presentation time via beepN (beepT=0.3)
% beepN   Time of one movement(s) (varies a lot between attempts)
%   70      1
%   80      0.96
%   90      1.098
%   100     1.26
%   150     2.33
beepFrequency=600; % frequency of beeps

%% Produce Hann window (to smooth out beep string)
hannWindow = hann(fs*beepT)';

%% Produce WGN (white gaussian noise)
length=round(beepT * fs);
mu=0; sigma=2;     % define mean and SD
WGN0=[];
for i=1:beepN
    WGN0(i,:)=sigma*randn(length,1)+mu;
end

% determine the magnitude of WGN (N/N+S) according to SNR
WGN=WGN0*(1-1/(1+1/snr));

%% Signals
% Standard sound 
beepStandard_o=sin(linspace(0, beepT * beepFrequency * 2*pi,round(beepT * fs)));
beepStandard=beepStandard_o.*hannWindow; % add Hann window to smooth out the sound

% lower sound
delta=linspace(1,0.1,beepN); % set level difference between beeps in two channels
signalLower=[];
for j=1:beepN
    signalLower(j,:)=real(ifft(fft(beepStandard)*delta(j)));
end

%% Play Sound
tic;
for beepCount=1:beepN
    % Add WGN to signals 
    %standardPlusWGM = awgn(beepStandard,snr,'measured'); % 'measure': awgn measures the power of x before adding noise.
    %lowerPlusWGM = awgn(signalLower(beepCount,:),snr,'measured');

    % Add background WGN 
    standardPlusWGM=beepStandard+WGN(beepCount,:);
    lowerPlusWGM=signalLower(beepCount,:)+WGN(beepCount,:);
    
    if signalDirection == -1     % signal goes to left
        sound([standardPlusWGM;lowerPlusWGM],fs);
    elseif signalDirection == 1  % signal goes to right
        sound([lowerPlusWGM;standardPlusWGM],fs);
    end
end
toc;
