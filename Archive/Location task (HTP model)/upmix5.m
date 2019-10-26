function [l, r, c, sl, sr, sub] = upmix5(x, fs, mode)

%--------------------------------------------------------------------
% upmix5
%
% Upmixes input stereo track to 5.1 surround
%
% Input parameters
% x: Input signal
% fs: sample rate of x in samples per second
% mode: upMix mode: 'proLogic' or 'music'
% Returns:
% l: left channel
% r: right channel
% c: center channel
% sl: surround left channel
% sr: surround right channel
% sub: subwoofer channel
%--------------------------------------------------------------------
%--------------------------------------------------------------
% DEFINE CONSTANTS, SIGNALS
%--------------------------------------------------------------
% Mixing gains for left and right stereo tracks for
% each of the six upmixed channels
gains = [1 0 10^(-10/20) 0.8165 0.5774 10^(3/20);
0 1 10^(-10/20) 0.5774 0.8165 10^(3/20)];
% delays for each of the six upmixed channels
delays = [0 0 5e-3 20e-3 20e-3 0];
%get stereo channels
stereo_left = x(:,1);
stereo_right = x(:,2);

%--------------------------------------------------------------
% LOW PASS FILTERING (SIMULATING SUBWOOFER)
%--------------------------------------------------------------
% get filter coeffs
% [N_sub, Wn_sub] = ellipord(1000/(fs/2), 1100/(fs/2), .1, 60);
% [b_sub, a_sub] = ellip(N_sub,.1,60,Wn_sub,'low');
[b_sub, a_sub] = cheby1(5, .5, 300/22050, 'low');
%filter each left and right tracks
subl = filter(b_sub, a_sub, stereo_left);
subr = filter(b_sub, a_sub, stereo_right);

%--------------------------------------------------------------
% MIX STEREO TO SURROUND WITH DEFINED GAINS
%--------------------------------------------------------------
% front 3 channels are simple gains
l = gains(1,1)*stereo_left + gains(2,1)*stereo_right;
r = gains(1,2)*stereo_left + gains(2,2)*stereo_right;
c = gains(1,3)*stereo_left + gains(2,3)*stereo_right;
% surround channels require phase shifts
% shift stereo tracks
left_p90 = real((hilbert(stereo_left) - stereo_left)/i);
right_n90 = real((hilbert(-1*stereo_right) - (-1*stereo_right))/i);
%mix shifted tracks
sl_pre_shelf = gains(1,4)*left_p90 + gains(2,4)*right_n90;
sr_pre_shelf = gains(1,5)*left_p90 + gains(2,5)*right_n90;
% sub is simple gaining
sub = gains(1,6)*subl + gains(2,6)*subr;
% clear tracks from memory that are no longer needed
clear stereo_left; clear stereo_right;
clear left_p90; clear right_p90;
clear subl; clear subr;

%--------------------------------------------------------------
% PAN TO STRONGEST SIGNAL DYNAMICALLY (PROLOGIC MODE)
%--------------------------------------------------------------
if (strcmp(mode, 'proLogic'))
    % Iterate through in 20 ms blocks
    %find block constants
    blockSize = round(20e-3*fs);
    numBlocks = ceil(length(x)/blockSize);
    for I = 1:numBlocks
        %find start/end samples
        blockStart = (I-1)*blockSize+1;
        blockEnd = blockStart+min(blockSize-1,length(x)-blockStart);
        %find dynamic gains for this 20 ms block
        [upmixGains,iMaxRMS] = dyn_5UpmixGains( l(blockStart:blockEnd), r(blockStart:blockEnd), c(blockStart:blockEnd), sl_pre_shelf(blockStart:blockEnd), sr_pre_shelf(blockStart:blockEnd) );
        focus(I, 1:2) = [iMaxRMS(1) length(iMaxRMS)];

        %Apply Panning to this block by gaining
        l(blockStart:blockEnd) = l(blockStart:blockEnd)*upmixGains(1);
        r(blockStart:blockEnd) = r(blockStart:blockEnd)*upmixGains(2);
        c(blockStart:blockEnd) = c(blockStart:blockEnd)*upmixGains(3);
        sl_pre_shelf(blockStart:blockEnd) = sl_pre_shelf(blockStart:blockEnd)*upmixGains(4);
        sr_pre_shelf(blockStart:blockEnd) = sr_pre_shelf(blockStart:blockEnd)*upmixGains(5);
    end;

    % %TEST CODE
    % L_STRONG = find( focus(:, 1) == 1 )
    % R_STRONG = find( focus(:, 1) == 2 )
    % C_STRONG = find( focus(:, 1) == 3 )
    % SL_STRONG = find( focus(:, 1) == 4 )
    % SR_STRONG = find( focus(:, 1) == 5 )
    % MULTI_STRONG = find( focus(:, 2) > 1 )
    % clear uneeded signals
    clear focus;
end;

%--------------------------------------------------------------
% APPLY DELAYS TO CHANNELS
%--------------------------------------------------------------
l = delay(l, fs, delays(1));
r = delay(r, fs, delays(2));
c = delay(c, fs, delays(3));
if (strcmp(mode, 'proLogic'))
    sl_pre_shelf = delay(sl_pre_shelf, fs, delays(4));
    sr_pre_shelf = delay(sr_pre_shelf, fs, delays(5));
end;
sub = delay(sub, fs, delays(6));

%--------------------------------------------------------------
% FILTERING FOR SURROUND CHANNELS
%--------------------------------------------------------------
if (strcmp(mode, 'proLogic'))
% 1. LOW PASS FILTERING FOR SURROUND CHANNELS (PROLOGIC MODE)
    [N_lp, Wn_lp] = ellipord(7e3/(fs/2), 7.5e3/(fs/2), .1, 60);
    [b_lp,a_lp] = ellip(N_lp,.1,60,Wn_lp,'low');
    sl = filter(b_lp, a_lp, sl_pre_shelf);
    sr = filter(b_lp, a_lp, sr_pre_shelf);
elseif (strcmp(mode, 'music'))
    % 2. SHELVING FILTER FOR SURROUND CHANNELS (MUSIC MODE)
    [b_lp, a_lp] = shelf1(fs, 4e3, -20, 'hc');
    sl = filter(b_lp, a_lp, sl_pre_shelf);
    sr = filter(b_lp, a_lp, sr_pre_shelf);
end