% Guitarist Live!
% Daniel Mesham
% April 2018

close all;
addpath('./yin/');
addpath('./cepstrum/');
addpath('./midi/');

fprintf('\n');
disp('* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *');
disp('*                 Welcome to Guitarist Live!                        *');
disp('* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *');
fprintf('\n');
disp('When prompted, press ENTER to start a recording.');
disp('There will be a 3 second countdown, after which you can play a note');
disp('Guitarist will then print out the note you played.');
fprintf('\n');

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%   Options
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Fs = 44100;     % Sampling frequency
bits = 16;      % Bits/sample
T = 1;          % Duration (seconds)
T_pad = 0.25;   % Padding (time to remove from start, seconds)
plots = false;  % Plot the audio
WINDOW = 4000;  % 4000 sample window
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

rec = audiorecorder(Fs,bits,1);             % The recorder

if plots
    yFig = figure();
end

disp('Press ENTER to start a recording, or enter some text to quit.');
go = isempty(input('Ready? ', 's'));

while go
    pause(0.5);
    fprintf('\nRecording in 3'); pause(0.5);fprintf(' .'); pause(0.5);
    fprintf(' 2'); pause(0.5);fprintf(' .'); pause(0.5);
    fprintf(' 1'); pause(0.5);fprintf(' .'); pause(0.5);
    fprintf(' GO!\n');
    
    fprintf('\n *** RECORDING ***\n\n');
    recordblocking(rec, T + T_pad);
    fprintf('Done!\n\n');
    
    y = getaudiodata(rec);  % Get data
    y = y(T_pad*Fs:end);    % Remove padding time
    
    % Identify with YIN:
    [midi, error, time] = yinNote(y, Fs, WINDOW);
    note = midi2name(midi);
    fprintf('According to YIN:\n');
    fprintf('   The note played was %s.\n', note);
    fprintf('   It took %.1f milliseconds.\n', time);
    fprintf('   The quantisation error was %.3f %%.\n\n', error);
    
    % Identify with Cepstrum:
    [midi, error, time] = cepstrumNote(y, Fs, WINDOW);
    note = midi2name(midi);
    fprintf('According to CEPSTRUM:\n');
    fprintf('   The note played was %s.\n', note);
    fprintf('   It took %.1f milliseconds.\n', time);
    fprintf('   The quantisation error was %.3f %%.\n\n', error);
    
    if plots
        figure(yFig), plot(0:1/Fs:(length(y)-1)/Fs, y);
        xlabel('Time (s)'), ylabel('Signal'), title('Recorded Audio');
    end
    
    disp('Press ENTER to start a recording, or enter some text to quit.');
    go = isempty(input('Ready? ', 's'));
end