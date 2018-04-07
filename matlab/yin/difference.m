function d = difference(y, n0, W, T)
%DIFFERENCE Calculates the difference function the given signal and period
%   The sum of the square of the difference between a signal and values of 
%   itself that are T samples ahead of the current sample.
%   [Taken from the paper by De Cheveigné and Kawahara]
%   y - The signal of interest
%   n0 - The sample number at which to start
%   W - the window (how many samples to correlate over)
%   T - the delay or trial period (in samples)

d = 0;

for j = n0:n0+W-1
    d = d + (y(j) - y(j+T)).^2;
end

end

