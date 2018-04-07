function note = midi2name( m )
%MIDI2NAME Returns the name of a MIDI note
%   Returns the note name (eg 'E6') associated with the provided MIDI note
%   number.
%   Thanks to Joe Wolfe [https://newt.phys.unsw.edu.au/jw/notes.html]

if (m < 12) || (m > 127)
    error('Invalid MIDI note number (%d). Only MIDI note numbers between 12 and 127 inclusive can be named', m);
end

m = m - 12;
octave = floor(m/12);
noteInOctave = mod(m, 12);

note = '';

switch noteInOctave
    case 0
        note = 'C';
    case 1
        note = 'C#';
    case 2
        note = 'D';
    case 3
        note = 'D#';
    case 4
        note = 'E';
    case 5
        note = 'F';
    case 6
        note = 'F#';
    case 7
        note = 'G';
    case 8
        note = 'G#';
    case 9
        note = 'A';
    case 10
        note = 'A#';
    case 11
        note = 'B';
    otherwise
        note = '?';
end

note = sprintf('%s%d', note, octave);

end

