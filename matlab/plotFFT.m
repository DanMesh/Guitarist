% Guitarist
% Daniel Mesham
% 29 March 2018

function plotFFT(y, Fs, Fmax, name)
%PLOTFFT Plots the FFT of the given audio clip
%   Shows the frequency response in Hz up to Fs/2

if ~exist('Fmax', 'var')
    Fmax = Fs/2;            
end
if ~exist('name', 'var')
    name = 'Unnamed';            
end

N = length(y);
f = 0:Fs/(N-1):Fs;

Y = abs(fft(y));

i = find(f >= Fmax, 1) - 1;

hold on;
legend(gca,'off');

plot(f(1:i), Y(1:i), 'DisplayName', name);

hold off;
legend(gca,'show');
title('Frequency Response'), xlabel('Frequency (Hz)'), ylabel('Magnitude');

end

