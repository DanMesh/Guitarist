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

notes = string.empty(0,N);
stddev = zeros(1,N);
error = zeros(1,N);

%[y, Fs] = getAudio(files);

fprintf('\n%-8s %-8s %-8s \n', 'TRUTH', 'EST', 'STD DEV');
disp('----------------------------');

for i = 1:N
    [y, Fs] = getAudio(files(i));
    periods = getPeriod(y, Fs);
    T = mean(periods);
    notes(i) = freq2name(1/T);
    
    
    % Analyse results
    splt = strsplit(files(i), '_');
    truth = erase(splt(1), dataDir);
    stddev(i) = std(periods)/T;
    error(i) = truth ~= notes(i);
    fprintf('%-8s %-8s %.6f \n', truth, notes(i), stddev(i));
end

fprintf('\n');
fprintf('Worst case std dev = %.6f \n', max(stddev));
fprintf('Errors = %d / %d \n', sum(error), N);
fprintf('\n');