function y = torso(x, fs, theta, phi)

%--------------------------------------------------------------------
%   torso
%   Applies a delay to input signal based on a single
%   shoulder reflection for given position, as a part
%   of a head related transfer function
%
%   Input parameters
%           x: Input signal
%           fs: sample rate of x in samples per second
%           theta: angle (in degrees) in plane around head
%           phi: angle (in degreees) of elevation
%   Returns:
%           y: delayed input, zero padded
%--------------------------------------------------------------------
 
% Calculate delay in ms
T_sh = 1.2*(180 - theta)/180 * (1 - 0.00004*((phi - 80)*180/(180 + theta)));
 
% Delay and return input signal
delay_sh = round(T_sh/1000*fs);
y = zeros(1, length(x) + delay_sh);
y(delay_sh+1:length(y)) = x;

