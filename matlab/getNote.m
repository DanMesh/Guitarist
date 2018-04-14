function [note, stdDev, time] = getNote( y, Fs )
%GETNOTE Calculates the fundemantal note of the waveform
%   Uses YIN pitch detection to calculate the fundamental period of the
%   signal y (sampling frequency Fs) and converts it to a MIDI note number.
%   Also returns the standard deviation % of the estimated frequencies
%   corresponding to 'note'.
%   Also returns the time taken to estimate the note in milliseconds.

% Guitar parameters
note_min = 40;      % Lowest note:  E2, 6th string open
note_max = 83;      % Highest note: B5, 1st string fret 19

% Max & min periods in samples
T_max = Fs/midi2freq(note_min);
T_min = Fs/midi2freq(note_max);

% Period range to allow for at least 5 times the longest period
T_range = round(4.5*T_min):round(5.5*T_max);

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%   Design Choices
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
W = 3*T_max;         % Window size = 3 x max period expected
threshold = 0.2;     % Threshold value for the CMNDIFF
num_ind = 100;       % The minimum number of indices that must be below the threshold
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

tic;    % Start timer

% Choose starting sample to be the loudest point
n0  = find(y == max(y));

% Calculate the CMNDIFF
cmnd = cmndiff(y, n0, W, T_range);

% Extract the (indices of) parts of CMND that were below the threshold
% If necessary, increase the threshold until enough indices are found
ind = find(cmnd < threshold);
while length(ind) < num_ind
    threshold = 1.1*threshold;
    ind = find(cmnd < threshold);
end

% Iterate through indices and work out periods as you go
dip_start = ind(1);         % First index in dip
dip_end = ind(1);           % Last index in dip
T = [];                     % The calculated dip times

for k = 2:length(ind)
    % Check if the current index is adjacent to the previous index
    if ind(k) == dip_end + 1
        % Is consecutive, so add to current dip
        dip_end = ind(k);
    else
        % Not consecutive: process, and start new dip
        
        % Only interpolate if there are more than 3 points
        if dip_end - dip_start > 2
            % Extract dip y-values
            i = dip_start:dip_end;                  % Indices in dip
            c_dip = cmnd(dip_start:dip_end);        % The part of y in the dip
            i_min = i(find(c_dip == min(c_dip)));   % Find the lowest point's index
            n3 = i_min-1:i_min+1;                   % Lowest 3 indices
            c3 = cmnd(n3);                          % Lowest 3 y values
            n_min = interpolate(n3, c3);            % Find the local minimum sample value
            T = [T (n_min/Fs)];                       % Save the dip time to T
        end
        
        % Start new dip
        dip_start = ind(k);
        dip_end = ind(k);
    end
end

% Convert dip times to periods
for k = length(T):-1:2
    T(k) = T(k) - T(k-1);
end

T = T(2:end);                           % Ignore first value
[notes, errors] = freq2midi(1./T);      % Convert periods to MIDI note numbers
[note, F] = mode(notes);                % Take the mode as the fundamental

time = 1000*toc; % Stop timer, record time in ms

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%   Error Analysis
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
maxNote = max(notes);       % Highest note found
numWrongNotes = length(notes) - F;  % F = no. of fundamentals

normErrors = errors(find(notes == note))/midi2freq(note);   % Normalised frequency errors
stdDev = 100*sqrt( sum(normErrors.^2)/F );                  % Std deviation as percentage

end

