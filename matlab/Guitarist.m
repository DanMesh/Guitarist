% Guitarist
% Main Script
% Daniel Mesham 2018

% Choose test parameters: - - - - - - - - - - - - - - - - - - -
doYIN = false;
DEBUG = false;
EXCEL = true;       % Print results in Excel readable table
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

global WINDOW;

close all;
addpath('./yin/');
addpath('./midi/');
addpath('./cepstrum/');

dataDir = '../data/';

D = [dir(fullfile(dataDir, '*.m4a')); dir(fullfile(dataDir, '*.aifc'))];    % Get audio contents of data directory
N = length(D);                          % Number of files
files = string.empty(0,N);              % List of file paths

for i = 1:N
    files(i) = strcat(dataDir, D(i).name);
end

% Error checking
if DEBUG
    files = strcat(dataDir, string('E3_4_1.m4a'));
    N = 1;
end

% Choose method: true = YIN, false = cepstrum
if ~EXCEL           % Only print if not exporting for Excel
    if doYIN
        disp('Method: YIN');
    else
        disp('Method: Cepstrum');
    end
end


notes = string.empty(0,N);
error = zeros(1,N);
mistake = zeros(1,N);
octave = zeros(1,N);
time = zeros(1,N);

if ~EXCEL
    fprintf('\n%-8s %-8s %-10s %-13s %s\n', 'TRUTH', 'EST', 'ERROR(%)', 'TIME(ms)', 'FILE');
    disp('---------------------------------------------------------------');
end

for i = 1:N
    [y, Fs] = getAudio(files(i));

    if doYIN
        [midi, error(i), time(i)] = yinNote(y, Fs, WINDOW);
    else
        y = y(1:end, 1);
        [midi, error(i), time(i)] = cepstrumNote(y, Fs, WINDOW);
    end
    notes(i) = midi2name(midi);
    
    % Analyse results
    splt = strsplit(files(i), '_');
    truth = erase(splt(1), dataDir);
    mistake(i) = truth ~= notes(i);
    
    if mistake(i)
        octave(i) = extractBefore(truth, strlength(truth)) == extractBefore(notes(i), strlength(notes(i))); 
    end
    
    if ~EXCEL
    fprintf(1+mistake(i), '%-8s %-8s %6.3f       %5.1f      %s \n', truth, notes(i), error(i), time(i), files(i));
    end
end

if EXCEL
    fprintf('%.2f; %.3f; %.3f; %.3f; %.3f; %d; %d\n', WINDOW, mean(error), max(error), mean(time), max(time), sum(mistake), sum(octave));
else
    fprintf('\nSTATS:\n');
    fprintf('Mean error  = %.3f %% \n', mean(error));
    fprintf('Worst error = %.3f %% \n', max(error));
    fprintf('\n');
    fprintf('Mean time   = %.3f ms \n', mean(time));
    fprintf('Worst time  = %.3f ms \n', max(time));
    fprintf('\n');
    fprintf('Mistakes = %d / %d  (%.0f %%)\n', sum(mistake), N, 100*sum(mistake)/N);
    fprintf('> Octave = %d / %d  (%.0f %%)\n', sum(octave), N, 100*sum(octave)/N);
    fprintf('\n');
end