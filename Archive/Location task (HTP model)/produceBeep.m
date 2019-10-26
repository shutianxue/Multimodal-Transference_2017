function produceBeep(fs,pitch,beepT,azimuth,elevation)

% Inputs:
% fs: sample rate
% beepFrequency: the pitch of beep, in Hz
% beepT: duration ofone beep, in sec

beepMatrix_o=sin(linspace(0, beepT * pitch * 2*pi,round(beepT * fs)));
%% Produce Hann window (to smooth out beeps)
%hannWindow = hann(fs*beepT);
%hannWindow=hannWindow';
%beepMatrix=hannWindow.*beepMatrix_o;

y = hrtf_model(beepMatrix_o, fs, azimuth, elevation);

sound(y,fs);
