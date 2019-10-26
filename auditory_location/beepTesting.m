
beepT=0.5;
pitch=2000;
fs=48000;
elevation=30;

clc;
fprintf('0 to 180 degree\n');
for n=0:10:180
    fprintf('%d\n',n);
    produceBeep(fs,pitch,beepT,n,elevation);
    WaitSecs(beepT);
end
clc;
pause(1);


fprintf('0 to -180 degree\n');
for n=0:-10:-180
    fprintf('%d\n',n);
    produceBeep(fs,pitch,beepT,n,elevation);
    WaitSecs(beepT);
end

clc;