# Catto's Fantasy
A fantasy action-adventure GBA game written in [Nim](https://nim-lang.org/) starring my cat. 

Uses the [natu](https://github.com/exelotl/natu/) package for a convenient GBA interface to Nim.

## Building
You will need:
- Nim, to actually build it. Easiest way to get it is to get a binary from [choosenim](https://github.com/dom96/choosenim), or from the [nim-lang website](https://nim-lang.org/install.html), or use your operating system's package manager.
- [devkitPro](https://devkitpro.org/wiki/Getting_Started) on your path, for some miscellaneous ARM/GBA tooling.

First, clone the repository with `git clone https://github.com/IamRifki/CattoFantasy.git` then run `nim build`, `nim build` will then compile a .gba binary. Run with [mGBA](https://mgba.io/) or your favorite flash cart, and enjoy.

## Special thanks
- nocash and the gbadev.org people

For the extensive resources.

- exelotl et al

For the natu package.

- Vince94

For contributing some tunes.

## License
[MIT](./LICENSE).