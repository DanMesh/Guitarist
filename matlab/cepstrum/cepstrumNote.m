function [ midi, error, time ] = cepstrumNote( y, Fs, WINDOW )
%CEPSTRUMNOTE Determines the MIDI number of the given signal using Cepstrum
%   Given a signal, Y, with sampling frequency, Fs, CEPSTRUMNOTE returns
%   the MIDI note number corresponding to the best estimate of the
%   fundamental note in the signal. It also returns the quantisation error
%   in estimating that note, and the time taken to identify it (in
%   milliseconds).
%   If the WINDOW parameter is provided it will be used as the window
%   length.

% Guitar parameters
note_min = 40;      % Lowest note:  E2, 6th string open
note_max = 83;      % Highest note: B5, 1st string fret 19

% Max & min periods in seconds
T_max = 1/midi2freq(note_min);
T_min = 1/midi2freq(note_max);

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%   Design Choices (window length & start)
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
W = round(3*Fs*T_max);              % Window size = 3 x max period expected
n0  = find(y == max(y)) + 0.1*Fs;   % Window start
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if exist('WINDOW', 'var') && WINDOW > 1
    W = WINDOW;
end

y = y(n0:n0+W-1);

tic;

[c, t] = cepstrum(y, Fs);

keepHi = (t > 0.9*T_min);
keepHi = keepHi .* (t < 1.1*T_max);
c = c .* keepHi';

i = find(c == max(c), 1);

T3 = t([i-1 i i+1]);
c3 = c([i-1 i i+1]);

T = interpolate(T3, c3);
f = 1/T;

[midi] = freq2midi(f);
error = abs(100*(1 - f/midi2freq(midi)));

time = 1000*toc; % Stop timer, record time in ms

end

