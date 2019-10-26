function [StimValInit, MaxTtest, InitGuess] = GetParams(beepT)

MaxTtest = log10(100); % MAX test number
StimValInit = 80;      % initial test value (%)
InitGuess = 25;        % initial threshold guess(%) / can be higher for auditory tasks
