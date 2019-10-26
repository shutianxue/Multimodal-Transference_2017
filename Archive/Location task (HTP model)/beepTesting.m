
beepT=0.5;
pitch=2000;
fs=44100;
elevation=0;

clc;
fprintf('0 to 90 degree\n');
for n=0:10:90
    fprintf('%d\n',n);
    produceBeep(fs,pitch,beepT,n,elevation);
    WaitSecs(beepT);
end
clc;
pause(1);

fprintf('90 to 180 degree\n');
for n=90:10:180
    fprintf('%d\n',n);
    produceBeep(fs,pitch,beepT,n,elevation);
    WaitSecs(beepT);
end
clc;
pause(1);

fprintf('0 to -90 degree\n');
for n=0:-10:-90
    fprintf('%d\n',n);
    produceBeep(fs,pitch,beepT,n,elevation);
    WaitSecs(beepT);
end
clc;
pause(1);

fprintf('-90 to -180 degree\n');
for n=-90:-10:-180
    fprintf('%d\n',n);
    produceBeep(fs,pitch,beepT,n,elevation);
    WaitSecs(beepT);
end
clc;
pause(1);

clc;