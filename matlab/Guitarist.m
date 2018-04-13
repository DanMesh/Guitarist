% Main Script

close all;
addpath('./yin/');
addpath('./midi/');

files = [string('E2_6.m4a'), string('E3_4.m4a'), string('E4_1.m4a')];
files2 = 

notes = string.empty(0,3);
stddev = zeros(1,3);
error = zeros(1,3);

%[y, Fs] = getAudio(files);

fprintf('\n%-8s %-8s %-8s \n', 'TRUTH', 'EST', 'STD DEV');
disp('----------------------------');

for i = 1:length(files)
    [y, Fs] = getAudio(files(i));
    periods = getPeriod(y, Fs);
    T = mean(periods);
    notes(i) = freq2name(1/T);
    
    
    % Analyse results
    splt = strsplit(files(i), '_');
    truth = splt(1);
    stddev(i) = std(periods)/T;
    error(i) = truth ~= notes(i);
    fprintf('%-8s %-8s %.6f \n', truth, notes(i), stddev(i));
end

fprintf('Worst case std dev = %.6f \n', max(stddev));
fprintf('Errors = %d \n', sum(error));