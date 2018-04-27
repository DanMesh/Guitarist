# Guitarist
EEE4114F Digital Signal Processing project for monotonic pitch detection.

## What it can do
Guitarist can identify notes in audio files, or notes played to the computer's microphone using **GuitaristLive**.

### Note estimation from an audio file
Guitarist can use either the YIN or Cepstrum pitch detection techniques to identify the fundamental note played in a given audio clip. This can be done iteratively using `Guitarist.m` to produce large sets of results when the window length (number of smaples processed) is varied.

To iterate over a range of window lengths, run the program from the `matlab/` directory using the follwing code:
```matlab
for WINDOW = 500:50:1000
    Guitarist
end
```
This will use all audio in `data/` to test the algorithm for window lengths between 500 and 1000 samples, in 50 sample increments.

### GuitaristLive
You can also identify notes on the fly with `GuitaristLive.m`. This will listen to a note you play and identify it using both algorithms. Simply run the script and keep pressing ENTER to identify new notes.

## Audio file requirements
To test on a batch of audio files they must:
- be saved in `data\`
- have the file extension `.m4a` or `.aifc` (this can be changed in `Guitarist.m`)
- be named starting with the standard note name followed by an underscore (e.g. `F#3_someInfo.m4a` or `A5_someInfo.aifc`)
