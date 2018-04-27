function [ midi, error, time ] = yinNote( y, Fs, WINTHR )
%YINNOTE Determines the MIDI number of the given signal using YIN
%   Given a signal, Y, with sampling frequency, Fs, YINNOTE returns the
%   MIDI note number corresponding to the best estimate of the fundamental
%   note in the signal. It also returns the quantisation error in
%   estimating that note, and the time taken to identify it (in
%   milliseconds).
%   If the WINTHR parameter is provided it will be used as either the
%   threshold or the window length according to:
%       0 < WINTHR < 1: Used as the CMND threshold
%       WINTHR >= 1:    Used as the window length

% Guitar parameters
note_min = 40;      % Lowest note:  E2, 6th string open
note_max = 83;      % Highest note: B5, 1st string fret 19

% Max & min periods in samples
T_max = Fs/midi2freq(note_min);
T_min = Fs/midi2freq(note_max);

% Period range to allow for at least 5 times the longest period
%T_range = round(4.5*T_min):round(5.5*T_max);
T_range = round(0.5*T_min):round(2*T_max);

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%   Design Choices
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
W = 3*T_max;         % Window size = 3 x max period expected
threshold = 0.2;     % Threshold value for the power ratio
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if exist('WINDOW', 'var') && WINTHR > 0
    if WINTHR < 1               % If window/threshold is a fraction, it must be a threshold
        threshold = WINTHR;
    else                        % Otherwise, it's a window length
        W = WINTHR;
    end
end

tic;    % Start timer

% Choose starting sample to be shortly after the loudest point
n0  = find(y == max(y)) + 0.1*Fs;

cmnd = cmndiff(y, n0, W, T_range);
%plot(T_range, cmnd), title('Candidate Period vs CMND');%TRACE

ind = find(cmnd <= threshold);

% Catch case where nothing is below threshold
if isempty(ind)
    warning('No dips below default threshold, increasing threshold.');
    while isempty(ind)
        threshold = threshold * 1.05;
        ind = find(cmnd <= threshold);
    end
end

last = 1;
while (last < length(ind))&& (ind(last+1) == ind(last)+1)
    last = last + 1;
end

dip = ind(1:last);  % Indices in first dip only
PR_dip = cmnd(dip);
i = find(PR_dip == min(PR_dip));  % Index of lowest point
n = dip(i);

T3 = T_range([n-1 n n+1]);          % Lowest 3 periods
PR3 = cmnd([n-1 n n+1]);              % Lowest 3 points

T = interpolate(T3, PR3);
f = Fs/T;

[midi, error] = freq2midi(f);
error = abs(100*(1 - f/midi2freq(midi)));

time = 1000*toc; % Stop timer, record time in ms

end

