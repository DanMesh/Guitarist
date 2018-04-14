% Main Script

close all;
addpath('./yin/');
addpath('./midi/');

dataDir = '../data/';

D = dir(fullfile(dataDir, '*.m4a'));    % Get audio contents of data directory
N = length(D);                          % Number of files
files = string.empty(0,N);              % List of file paths



for i = 1:N
    files(i) = strcat(dataDir, D(i).name);
end

% Error checking
DEBUG = false;
if DEBUG
    files = strcat(dataDir, string('C5_1_1.m4a'));
    N = 1;
end


notes = string.empty(0,N);
MSE = zeros(1,N);
error = zeros(1,N);
time = zeros(1,N);

fprintf('\n%-8s %-8s %-10s %-13s %s\n', 'TRUTH', 'EST', 'MSE(%)', 'TIME(ms)', 'FILE');
disp('---------------------------------------------------------------');

for i = 1:N
    [y, Fs] = getAudio(files(i));
    [midi, MSE(i), time(i)] = getNote(y, Fs);
    notes(i) = midi2name(midi);
    
    % Analyse results
    splt = strsplit(files(i), '_');
    truth = erase(splt(1), dataDir);
    error(i) = truth ~= notes(i);
    fprintf('%-8s %-8s  %.3f        %5.1f      %s \n', truth, notes(i), MSE(i), time(i), files(i));
end

fprintf('\nSTATS:\n');
fprintf('Mean std dev  = %.3f %% \n', mean(MSE));
fprintf('Worst std dev = %.3f %% \n', max(MSE));
fprintf('\n');
fprintf('Errors = %d / %d \n', sum(error), N);
fprintf('\n');