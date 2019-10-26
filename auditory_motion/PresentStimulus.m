function PresentStimulus(snr, signalDirection, beepT)

% this script produces moving beeps (signal + Gaussian white noise)
 
fs        = 48000;
beepN     = 20;          % number of beeps in one trial 
pitch     = 1000;
elevation = 30;

%% Produce WGN (white gaussian noise)
mu=0; sigma=2;     % define mean and SD
% determine the magnitude of WGN according to SNR
snrPara=1-1/(1+1/snr);

%% Signals
% Standard sound 
beepStandard=sin(linspace(0, beepT * pitch * 2*pi,round(beepT * fs)));
azimuthBox=6:6:180;

%% Play Sound
for beepCount=1:beepN
    y=hrtf_kemar(beepStandard, azimuthBox(beepCount)*signalDirection, elevation);
    [leng,~]=size(y);
    WGN1=snrPara*(sigma*randn(leng,1)+mu);
    WGN2=snrPara*(sigma*randn(leng,1)+mu);
    y=y+[WGN1,WGN2];
    % Add Hann window to smooth out the sound
    %hannWindow = hann(fs*beepT)';
    %y=y.*hannWindow;
    sound(y,fs);
    WaitSecs(beepT);
end
