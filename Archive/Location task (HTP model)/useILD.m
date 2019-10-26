beepT=1;
pitch=500;
fs=48000;

beepMatrix_o=sin(linspace(0, beepT * pitch * 2*pi,round(beepT * fs)));
hannWindow = hann(fs*beepT);
beepMatrix=hannWindow.*beepMatrix_o';

ILD=[0,0.32:0.1:1.1,1.1:0.15:1.5,1.5:0.2:1.8];
ILD2=ILD*sqrt(10);
%ILD=[0.32,0.6,0.85,1.15,1.4,1.5,1.6,1.7,1.75,1.8]*sqrt(10);
beep=[beepMatrix,beepMatrix];

for n=1:length(ILD)
    beep(:,2)=beep(:,2)/ILD2(n);
    fprintf('%d\n',ILD(n))
    sound(beep,fs);
    %WaitSecs(beepT);
    pause(beepT);
end
