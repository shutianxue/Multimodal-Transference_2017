function [answer, anstime]=get_key(keys, wait, t0)

% === INPUTS ===
% keys:   key numbers we are looking for. scalar for one key, or row vector of key numbers
%           key numbers are as defined by KbCheck function
% wait:  if = 1, waits for input for unlimited; 
%        if = 2 waits for lmimited time; 
%        if = 0 looks for it just at this instant.

% === OUTPUTS ===
% answer:  scalar keyboard code
%          0 = no key pressed (if wait = 0)
%          -1 = lower
%          1 = higher
% anstime: time answer returned, 0 = no key pressed (if wait=0)


tDelta=5;           % time limitation for making a choice
    

if wait==1          % waits until key is pressed
    answer=[];
    while isempty(answer)
        [kch, anstime, code] = KbCheck;
        answer=intersect(find(code),keys);
    end;
elseif wait == 2
    answer = [];
    while isempty(answer)
        [kch, anstime, code] = KbCheck;
        if code(KbName('ESCAPE')) == 1
            close all;
            sca;
            return;
        else
            answer=intersect(find(code),keys);
        end
        
        if GetSecs > t0+tDelta
            answer = -1; % time's up
        end
    end 
else
    [kch, anstime, code] = KbCheck;
    answer=intersect(find(code),keys);
    if isempty(answer)
        
        answer=0;
        anstime=0;
    end
end