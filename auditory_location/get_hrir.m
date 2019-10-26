function h= get_hrir(theta,phi)

%--------------------------------------------------------------------
% Returns a (stereo) head related impulse response which matches
% closest the input angles. The IR is obtained from an MIT media
% lab's HRTF Measurements of a KEMAR Dummy-Head Microphone which
% can be found at http://sound.media.mit.edu/KEMAR.html
%
% Inputs:
%      y: input sound
%      theta: angle (in degrees) in plane around head (0~180 is right; negative are left)
%      phi: angle (in degreees) of elevation

% Returns:
%      h: HRIR matching closest theta and phi
%--------------------------------------------------------------------

%% Phi (elevation)
% Define available locations:
elevations = -40:10:90;
diff = Inf; % returns the IEEE® arithmetic representation for positive infinity
elev_match = 1;

% Determine which phi is best match based on search of values in elevations; record the index
for I = 1:length(elevations)
    this_diff = abs(elevations(I)-phi);
    if this_diff <= diff 
        diff = this_diff;
        elev_match = I;
    end
end

%% Theta (azimuth)
% Calculate best theta match knowing the linear spacing between each theta
theta_increments = [6.5,6,5,5,5,5,5,6,6.5,8,10,15,30,360]; % spacing between thetas for corresponding phi

selected_theta_incre = theta_increments(elev_match);
num_incr = round(abs(theta)/selected_theta_incre);
theta_match = floor(num_incr*selected_theta_incre);

while theta_match > 180
    num_incr = num_incr-1;
    theta_match = floor(num_incr*theta_increments(elev_match));
end


%% load HRIR from the KEMAR file 
% concatonate strings to make appropriate file name 
% name format: [H*e&&&a.wav] (* is phi in min digits; &&& is three digit phi, zero padded)
line_elevation=int2str(elevations(elev_match));
filename = strcat( 'HRIR\elev',line_elevation,'\H',line_elevation,'e');
line_theta = int2str(theta_match);
needed_zeros = 3-length(line_theta);
if (needed_zeros > 0)
    for I = 1:needed_zeros
        line_theta = strcat('0',line_theta);
    end
end
filename = strcat(filename,line_theta,'a.wav');
% now read file with 'filename' into memory
[x,~] = audioread(filename); % x is the HRIR from the file

%% if theta is negative
% Range of theta if theta was negative, we are to the left of the frontal plane.
% only thetas to right (positive: 0 to 180) of plane are measured,
% but we can use these for left by swapping the l/r hrirs for the
% absolute value of theta (i.e., left HRTF is same as right HRTF but swapping stereo tracks)
h = zeros(size(x));
if theta < 0
    h(:,1) = x(:,2);
    h(:,2) = x(:,1);
else
    h(:,1) = x(:,1);
    h(:,2) = x(:,2);
end