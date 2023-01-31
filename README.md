# AnsatzX Mokit_brew

This repository provides package build instructions for [mokit](https://gitlab.com/jxzou/mokit) compatible with the [Homebrew toolchain](https://brew.sh).

## How do I install these formulae?
You can install *mokit* by tapping this repository

This repo require you install miniconda via homebrew and install numpy 

```
brew install --cask miniconda
conda init bash (or zsh ) 
conda activate base
pip install numpy
```

Then 

`brew install ansatzx/homebrew-mokit/mokit`

Or `brew tap ansatzx/homebrew-mokit` and then `brew install mokit`.

Available programs are

- [mokit](https://gitlab.com/jxzou/mokit):
  Molecular Orbital KIT


## License

The package build files are available under a BSD-2-Clause license.

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).