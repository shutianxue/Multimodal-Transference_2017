function PlayBeep(frequency,beepTime,fs)

y=sin(linspace(0, beepTime * frequency * 2*pi,round(beepTime * fs)));
sound(y,fs);

%% Below are outdated
%{
%USAGE:
%    beep
%    beep(w)    specify frequency (200-1,000 Hz)
%    beep(w,t)     "       "       and duration in seconds
%
fs=65000;  %sample freq in Hz (1000-65535 Hz)   
           % it was 8192 when using SOUND command at the end of this code

if (nargin == 0)
   frequency=1000;            %default
   beepTime = [0:1/fs:.2];   %default
elseif (nargin == 1)
   beepTime = [0:1/fs:.2];   %default
elseif (nargin == 2)
   beepTime = [0:1/fs:beepTime];  
end


%one possible wave form
wave=sin(2*pi*frequency*beepTime);    

Snd('Play',wave,fs); 
Snd('Wait');
Snd('Quiet');
Snd('Close');
%}
