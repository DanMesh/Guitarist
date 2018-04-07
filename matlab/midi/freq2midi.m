function [ m, e ] = freq2midi( f )
%FREQ2MIDI Converts a frequency to a MIDI note number
%   Given a frequency f in Hz, this function returns the MIDI note number m.
%   Thanks to Joe Wolfe [https://newt.phys.unsw.edu.au/jw/notes.html]
%   
%   In the event that the MIDI note is not a whole number, m will be
%   rounded to the nearest whole number, and the error e will be the change
%   in m due to rounding.
%   The exact value of m can be found by m_exact = m - e

m_exact = 12*log2(f/440) + 69;

m = round(m_exact);
e = m - m_exact;

end

