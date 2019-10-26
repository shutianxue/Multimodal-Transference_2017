function [y, l, r, c, sl, sr, sub] = spatialize_5point(x, fs, hrtfMode, upMixMode)

%--------------------------------------------------------------------
% spatialize_5point
%
% Upmixes input stereo track to 5.1 surround and mixes all
% channels with HRTF spatialization
%
% Input parameters
% x: Input signal
% fs: sample rate of x in samples per second
% hrtfMode: hrtf mode: 'kemar' for hrir, 'model' for model.
% upMixMode: upMix mode: 'proLogic' or 'music'

% Returns:
% y: mixed 5.1 spatialized
% l: left channel spatialized
% r: right channel spatialized
% c: center channel spatialized
% sl: surround left channel spatialized
% sr: surround right channel spatialized
% sub: subwoofer channel
%--------------------------------------------------------------------

theta = [-30 30 0 -110 110];
phi = [0 0 0 0 0];

%--------------------------------------------------------------
% UPMIX TO SURROUND SOUND
%--------------------------------------------------------------
[up_l up_r up_c up_sl up_sr sub] = upmix5(x, fs, upMixMode);
clear x;
%--------------------------------------------------------------
% SPATIALIZE EACH UPMIXED CHANNELS (not subwoofer)
%--------------------------------------------------------------
hrtf_up_l = hrtf(up_l, fs, theta(1), phi(1), hrtfMode);
clear up_l;
hrtf_up_r = hrtf(up_r, fs, theta(2), phi(2), hrtfMode);
clear up_r;
hrtf_up_c = hrtf(up_c, fs, theta(3), phi(3), hrtfMode);
clear up_c;
hrtf_up_sl = hrtf(up_sl, fs, theta(4), phi(4), hrtfMode);
clear up_sl;
hrtf_up_sr = hrtf(up_sr, fs, theta(5), phi(5), hrtfMode);
clear up_sr;
%--------------------------------------------------------------
% DOWNMIX TO STEREO
%--------------------------------------------------------------
% find lengths of each track
lengths = [ length(hrtf_up_l(:,1)) length(hrtf_up_r(:,1)) length(hrtf_up_c(:,1)) length(hrtf_up_sl(:,1)) length(hrtf_up_sr(:,1)) length(sub)];
max_size = max( lengths );
A18
% memory allocation
y = zeros(max_size, 2);
% mix zero padded signals to output
y(1:lengths(1), :) = y(1:lengths(1), :) + hrtf_up_l;
l = hrtf_up_l;
clear hrtf_up_l;
y(1:lengths(2), :) = y(1:lengths(2), :) + hrtf_up_r;
r = hrtf_up_r;
clear hrtf_up_r;
y(1:lengths(3), :) = y(1:lengths(3), :) + hrtf_up_c;
c = hrtf_up_c;
clear hrtf_up_c;
y(1:lengths(4), :) = y(1:lengths(4), :) + hrtf_up_sl;
sl = hrtf_up_sl;
clear hrtf_up_sl;
y(1:lengths(5), :) = y(1:lengths(5), :) + hrtf_up_sr;
sr = hrtf_up_sr;
clear hrtf_up_sr;
y(1:lengths(6), :) = y(1:lengths(6), :) + [sub sub];