function [ note ] = freq2name( f )
%FREQ2NAME Converts a note frequency to the note name
%   Calculated the most liekly note name for the given frequency.

note = midi2name(freq2midi(f));

end

