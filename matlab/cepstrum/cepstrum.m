function [ ceps, t ] = cepstrum( y, Fs )
%CEPSTRUM Returns the cepstrum of the signal
%   Returns the cepstrum and the time axis from the signal, y, with
%   sampling frequency Fs.
%
%   Daniel Mesham 2018

ceps = (abs(ifft(2*mag2db(abs(fft(y)))))).^2;
ceps = ceps(1:end,1);
t = 0:1/Fs:(length(y)-1)/Fs;

end

