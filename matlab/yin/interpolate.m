function [ N, MIN ] = interpolate(n, y)
%INTERPOLATE Uses parabolic interpolation to find a minimum
%   Takes in three sample numbers and corresponding values and outputs the
%   estimated minimum value, MIN, and corresponding sample number N.
%   Based on http://fourier.eng.hmc.edu/e176/lectures/NM/node25.html.
%   n   - the sample numbers
%   y   - the sampled values

if length(n) ~= 3
    error('Incorrect number of sample points in n. Exactly 3 sample numbers must be provided.');
end
if length(y) ~= 3
    error('Incorrect number of sample values in y. Exactly 3 sample values must be provided.');
end

a = n(1);
b = n(2);
c = n(3);

fa = y(1);
fb = y(2);
fc = y(3);

N = b + 0.5 * ( (fa-fb)*(c-b)^2 - (fc-fb)*(b-a)^2 ) / ( (fa-fb)*(c-b) + (fc-fb)*(b-a) );

MIN = fa*((N-b)*(N-c))/((a-b)*(a-c)) + fb*((N-c)*(N-a))/((b-c)*(b-a)) + fc*((N-a)*(N-b))/((c-a)*(c-b));

end

