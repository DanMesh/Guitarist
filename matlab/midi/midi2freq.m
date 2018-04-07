function f = midi2freq( m )
%MIDI2FREQ Converts a MIDI note number to a frequency in Hz
%   Given a MIDI not number, the function returns a frequency f in Hz
%   corresponding to that note.
%   Thanks to Joe Wolfe [https://newt.phys.unsw.edu.au/jw/notes.html]

f = 440 * 2^((m-69)/12);

end

