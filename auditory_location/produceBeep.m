function produceBeep(fs,pitch,beepT,azimuth,elevation)

% Inputs:
%       fs: sample rate
%       beepFrequency: the pitch of beep, in Hz 
%       beepT: duration ofone beep, in sec
%       azimuth: 0 is middle, 90 is extreme right, -90 is extreme left
%       elevation: -40 ~ 90

input=sin(linspace(0, beepT * pitch * 2*pi,round(beepT * fs)));
%% Produce Hann window (to smooth out beeps)
%hannWindow = hann(fs*beepT);
%hannWindow=hannWindow';
%input=hannWindow.*input;

y = hrtf_kemar(input, azimuth, elevation);
sound(y,fs);
