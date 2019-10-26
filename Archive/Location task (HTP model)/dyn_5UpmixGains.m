function [ upmixGains, iMaxRMS ] = dyn_5UpmixGains ( l, r, c, sl, sr )
%--------------------------------------------------------------------
% dyn_5UpmixGains
%
% called by upmix5.m for Prologi cmodel
% Calculates gains for each of 5 surround channels such that
% The dominant channel(s) is(are) gained up, while the remaining are
% gained down, preserving the total energy of all 5 tracks.
%
% Input parameters
% l: left channel
% r: right channel
% c: center channel
% sl: surround left channel
% sr: surround right channel
% Returns:
% upmixGains: gains for each of 5 surround tracks
% iMaxRMS: the indexes (relative to input order) of the
% dominant channel(s)
%--------------------------------------------------------------------
% factor for gains such that rms gains gain_up/gain_down = scaling_factor
scaling_factor = 2;
% calc rms's
rms = [ mean(l.^2) mean(r.^2) mean(c.^2) mean(sl.^2) mean(sr.^2) ];
% determine indeces of dominant(s) and weaker channels
iMaxRMS = find ( rms == max(rms) );
iNotMaxRMS = find ( rms < max(rms) );
% calc rms gains such that energy (total rms) is preserved
g = sym('g');
rmsGains( iMaxRMS ) = g;
rmsGains( iNotMaxRMS ) = g/scaling_factor;
g = solve( sum(rmsGains.*rms) - sum(rms) );
% find and return channel gains
upmixGains = eval(sqrt( eval(rmsGains) ));
% %TEST CODE
% origSumRMS = sum( [rms] )
%
% y_l = upmixGains(1)*l;
% y_r = upmixGains(2)*r;
% y_c = upmixGains(3)*c;
% y_s = upmixGains(4)*s;
%
% newRMS = [ mean(y_l.^2) mean(y_r.^2) mean(y_c.^2) mean(y_s.^2) mean(y_s.^2) ];
%
% newSumRMS = eval(sum( newRMS ))