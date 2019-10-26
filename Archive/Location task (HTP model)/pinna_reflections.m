function [y] = pinna_reflections(x, fs, theta, phi)

%--------------------------------------------------------------------
%   pinna_reflections
%
%   Applies a series of delays based on modelling the pinna
%   reflections for a given position.
%
%   Input parameters
%           x: Input signal
%           fs: sample rate of x in samples per second
%           theta: angle (in degrees) in plane around head
%           phi: angle (in degreees) of elevation
%   Returns:
%           y: sum of input plus 5 delayed versions of input
%--------------------------------------------------------------------
 
% compute angles in radians
theta = theta*pi/180;
phi = phi*pi/180;
 
% define constants
ro = [1 0.5 -1 0.5 -0.25 0.25];
A = [1 5 5 5 5];
B = [2 4 7 11 13];
D = [1 0.5 0.5 0.5 0.5];
 
% memory allocation
T_p = [0 0 0 0 0 0];
delay_p = [0 0 0 0 0 0];
 
% calculate 5 disting delays
for I = 2:6
    T_p(I) = A(I-1)*cos(theta/2)*sin(D(I-1)*(pi/2-phi)) + B(I-1);
    delay_p(I) = round(T_p(I)/1000 * fs);
end
 
% sum and return input plus 5 delayed copies
y = zeros(1,length(x)+max(delay_p));
temp_y = zeros(6, length(x)+max(delay_p));
for I = 1:6
    temp_y(I, (delay_p(I)+1):(delay_p(I)+length(x)) ) = x*ro(I);
    y = y + temp_y(I,:);
end
 
 
 
