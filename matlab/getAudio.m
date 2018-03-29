% Guitarist
% Daniel Mesham
% 29 March 2018

function [y, Fs] = getAudio()
%GETAUDIO Converts an audio file into a vector of signal values
%   Returns a tuple with the signal and the sampling frequency
    [y, Fs] = audioread('../data/E_4.m4a');
end