function T = getPeriod( y, Fs )
%GETPERIOD Calculates the fundemantal period of the waveform
%   Uses YIN pitch detection to calculate the fundamental period of the
%   signal y (sampling frequency Fs).

n0 = 11000;
W = 2000;
T_range = 0:10000; 
cmnd = cmndiff(y, n0, W, T_range);

% The threshold value for the CMNDIFF
% Needs to be designed/chosen
threshold = 0.2;

% Extract the (indices of) parts of CMND that were below the threshold
ind = find(cmnd < threshold);

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
        
        % Extract dip y-values
        i = dip_start:dip_end;                  % Indices in dip
        y_dip = y(dip_start:dip_end);           % The part of y in the dip
        i_min = i(find(y_dip == min(y_dip)));   % Find the lowest point's index
        n3 = i_min-1:i_min+1;                   % Lowest 3 indices
        y3 = y(n3);                             % Lowest 3 y values
        n_min = interpolate(n3, y3);            % Find the local minimum sample value
        T = [T n_min/Fs];                       % Save the dip time to T
        
        % Start new dip
        dip_start = ind(k);
        dip_end = ind(k);
    end
end

% Convert dip times to periods
for k = length(T):-1:2
    T(k) = T(k) - T(k-1);
end

end

