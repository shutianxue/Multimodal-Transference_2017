function [y] = delay(x, fs, t)

%--------------------------------------------------------------------
% delay
%
% Applies a delay to a vector (apply ITD)
%
% Inputs:
% x: Input signal (monoaural)
% fs: sample rate of x in samples per second
% t: delay to apply in seconds

% Returns:
% y: delayed input
%--------------------------------------------------------------------
% find delay in sampls
sample_delay = round(t*fs);
% delay input
y = [zeros(sample_delay, 1)' x']';