
function [y] = hrtf_model(input, fs, theta, phi)

%--------------------------------------------------------------------
%   hrtf_model
%
%   Applies a head-related transfer function to an input 
%   monoaural audio track using a head/torso/pinna model
%
%   Input parameters
%           x: Input signal
%           fs: sample rate of x in samples per second
%           theta: azimuth (0~180: right to left)
%           phi: elevation (0~180: bottom to top)
%   Returns:
%           y: [r l] stereo track in 3D for headphones
%--------------------------------------------------------------------
 
% 180 degrees gives a divide by zero, so if exactly 180 compensate
% for this by approximating with another (close) value
if (abs(theta) == 180)
    theta = 179 * sign(theta);
end
 
% Apply Head Shadowing to input (-theta for left ear)
r_hs = hsfilter(theta, fs, input);
l_hs = hsfilter(-theta, fs, input);
 
% Apply a torso delay to input (-theta for left ear)
r_sh = torso(input, fs, theta, phi);
l_sh = torso(input, fs, -theta, phi);
 
% Sum the head shadowed/torso delayed signals: 
% This is the signal that makes it to the outer ear (pre pinna)
r_on_pinna = zeros(1, max(length(r_hs),length(r_sh)));
r_on_pinna(1:length(r_hs)) = r_on_pinna(1:length(r_hs)) + r_hs;
r_on_pinna(1:length(r_sh)) = r_on_pinna(1:length(r_sh)) + r_sh;
 
l_on_pinna = zeros(1, max(length(l_hs),length(l_sh)));
l_on_pinna(1:length(l_hs)) = l_on_pinna(1:length(l_hs)) + l_hs;
l_on_pinna(1:length(l_sh)) = l_on_pinna(1:length(l_sh)) + l_sh;
 
% Apply pinna reflections to the prepinna signals (-theta for left ear)
r = pinna_reflections(r_on_pinna, fs, theta, phi);
l = pinna_reflections(l_on_pinna, fs, -theta, phi);
 
% Pad shorter signal with zeros to make both same length
if ( length(r) < length(l) )
    r = [r zeros(1,length(l)-length(r))];
else
    l = [l zeros(1,length(r)-length(l))];
end;
 
% return final headphone stereo track
y = [r',l'];

