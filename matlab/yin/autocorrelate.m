function R = autocorrelate(y, n0, W, T)
%AUTOCORRELATE Autocorrelates the given signal with its delayed self
%   Autocorrelate a signal with values of itself that are T samples ahead
%   of the current sample.
%   [Taken from the paper by De Cheveigné and Kawahara]
%   y - The signal of interest
%   n0 - The sample number at which to start
%   W - the window (how many samples to correlate over)
%   T - the delay or trial period (in samples)

R = 0;

for j = n0:n0+W-1
    R = R + y(j)*y(j+T);
end

end

