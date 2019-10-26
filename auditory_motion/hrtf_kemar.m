function y= hrtf_kemar(input, theta, phi)
%--------------------------------------------------------------------
% hrtf_kemar
%
% Applies a head-related transfer function to an input monoaural audio track using a HRIR obtained from
% MIT media lab's measurements, as documented in get_hrir.m
%
% Input parameters
%       x: Input signal
%       theta: angle (in degrees) in plane around head
%       phi: angle (in degreees) of elevation
% Returns:
%       y: [r l] stereo track in 3D for headphones
%--------------------------------------------------------------------

% get closest matching HRIR
h = get_hrir(theta, phi);
% convolve and return input with hrir
y(:,1) = conv(input, h(:,1));
y(:,2) = conv(input, h(:,2));