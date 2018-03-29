% Guitarist
% Daniel Mesham
% 29 March 2018

% Script to test audio capture & display functions
close all;

[y, Fs] = getAudio;

figure('name', 'Frequency Responses');
plotFFT(y, Fs, 1000, '1x');
plotFFT(y*2, Fs, 1000, '2x');

% Making the sound of the 6th string (fundamental frequency)
n = 0:Fs*2;
omega = 2*pi*82.41;
E2 = sin(n * omega/Fs);