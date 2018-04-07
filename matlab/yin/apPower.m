function P = apPower(y, n0, W, T)
%APPOWER Calculates the aperiodic power of the signal
%   The sum of the square of the sum of a signal and values of 
%   itself that are T samples ahead of the current sample.
%   [Taken from the paper by De Cheveigné and Kawahara]
%   y - The signal of interest
%   n0 - The sample number at which to start
%   W - the window (how many samples to correlate over)
%   T - the delay or trial period (in samples)

P = 0;

for j = n0:n0+W-1
    P = P + (y(j) + y(j+T)).^2;
end

end

