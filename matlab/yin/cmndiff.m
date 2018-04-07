function d = cmndiff(y, n0, W, T)
%CMNDIFF Calculates the cumulative mean normalised difference function
%   [Taken from the paper by De Cheveigné and Kawahara]
%   y - The signal of interest
%   n0 - The sample number at which to start
%   W - the window (how many samples to correlate over)
%   T - the delay or trial period (in samples)

diff = difference(y, n0, W, T);
sumDiff = zeros(size(diff));
for k = 2:length(sumDiff)
    sumDiff(k) = sumDiff(k-1) + diff(k);
end

d = difference(y, n0, W, T).*T./sumDiff;

for k = find(T==0)
    d(k) = 1;
end

end

