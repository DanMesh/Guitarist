% Guitarist
% Daniel Mesham
% 29 March 2018

function [y, Fs] = getAudio(filename)
%GETAUDIO Converts an audio file into a vector of signal values
%   Returns a tuple with the signal and the sampling frequency

if ~exists('filename', 'var')
    filename = 'E2_6.m4a';      % Default audio
end

[y, Fs] = audioread(strcat('../data/', filename));
end