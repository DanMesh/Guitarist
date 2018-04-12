function plotFFT(y, Fs, Fmax, name, dB)
%PLOTFFT Plots the FFT of the given audio clip
%   Shows the frequency response in Hz up to Fs/2

if ~exist('Fmax', 'var')
    Fmax = Fs/2;            
end
if ~exist('name', 'var')
    name = 'Unnamed';            
end
if ~exist('dB', 'var')
    dB = 'linear';
end

N = length(y);
f = 0:Fs/(N-1):Fs;

Y = abs(fft(y));

i = find(f >= Fmax, 1) - 1;

hold on;
legend(gca,'off');

if strcmp(dB, 'dB')
    plot(f(1:i), mag2db(Y(1:i)), 'DisplayName', name), ylabel('Magnitude (dB)');
else
    plot(f(1:i), Y(1:i), 'DisplayName', name), ylabel('Magnitude');
end

hold off;
legend(gca,'show');
title('Frequency Response'), xlabel('Frequency (Hz)');

end

