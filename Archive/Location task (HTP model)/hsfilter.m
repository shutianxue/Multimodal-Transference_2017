function [output] = hsfilter(theta, fs, input)
% Description:
% filters the input signal according to head shadowing
 
theta = theta + 90;
theta0 = 150 ;
alfa_min = 0.05 ;     
c = 340;  % speed of sound (m/s)
a = 0.09; % radius of head (in meters)
          % usually, radius of male is 3.66 inches, 9.3 cm; female is 3.31 inches, 8.4 cm
w0 = c/a;
alfa = 1+ alfa_min/2 + (1- alfa_min/2)* cos(theta/ theta0* pi) ;    
 
% numerator of Transfer Function
B = [(alfa+w0/fs)/(1+w0/fs), (-alfa+w0/fs)/(1+w0/fs)] ; 
% denominator of Transfer Function
A = [1, -(1-w0/fs)/(1+w0/fs)] ;                         

% calculate gdelay (ITD)
if (abs(theta) < 90)
    gdelay = - fs/w0*(cos(theta*pi/180) - 1)  ;
else
    gdelay = fs/w0*((abs(theta) - 90)*pi/180 + 1);
end;

% allpass filter coefficient
a = (1 - gdelay)/(1 + gdelay);

out_magn = filter(B, A, input);           % >> filter: filters the data in vector X with the filter described by vectors A and B 
output = filter([a,1],[1,a], out_magn);

