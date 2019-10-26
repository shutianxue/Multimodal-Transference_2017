function [StimValInit, MaxTtest, InitGuess] = GetParams
MaxTtest = log10(100); % MAX proportion of signals (%)
StimValInit = 50;      % initial proportion of signals (%), need to be easier
InitGuess = 25;        % initial threshold guess(%)
