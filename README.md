Software-based [active noise control](http://en.wikipedia.org/wiki/Active_noise_control) using your Mac's microphone and a set of plain earphones.

## Rationale

Do you want a quiet environment but work in an open office? Don't want to shell out £300 for a set of [Bose headphones](http://www.amazon.co.uk/gp/product/B0054JJ0QW)?

Then this project might be useful to you. We can emulate active noise control through signal processing by playing back an inverted interference sound wave of what you're hearing to your ear pieces. All you need is a computer with microphone, a set of ear pieces, and this amazing program.

## Description

Theoretically, by taking real-time audio from a computer's microphone and emiting an attenuated sound wave with the same amplitude but with inverted phase, we can cause interference to cancel out unwanted noise.

The 2d-spectrograph below illustrates a recorded [10-second wav file](./data/ambience.wav) and its inverted sound wave. When both files are played together, they cancel each other out.

![spectrographic plot of original and inversed audio](./spectro.png)

## Execute

To run the program, do `bundle exec ruby script.rb`

## Credits

A Forward hackday project by [Max](https://github.com/maxdupenois), [Sid](https://github.com/sdawara), and [Paul](https://github.com/Quantisan).