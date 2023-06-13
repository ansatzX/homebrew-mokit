# AnsatzX Mokit_brew

This repository provides package build instructions for [mokit](https://gitlab.com/jxzou/mokit) compatible with the [Homebrew toolchain](https://brew.sh).

## How do I install these formulae?

You can install *mokit*  by tapping this repository

### Install Releases with python plugins.

```
brew install ansatzx/homebrew-mokit/mokit --with-py39
```

Or

```
brew tap ansatzx/homebrew-mokit
brew install mokit --with-py39 
```

You have options `--with-pyxxx`, varying from 38 to 311, since m1 chips do not have 37 and lower python. 

If you do not want python part (pyscf) of mokit, do not write this option.

### Install latest Git version (HEAD)

Use option `--HEAD` to get latest commit

```
brew install mokit --with-py39  --HEAD
```

It's very suitable for pros.

## Update 

```
brew update && brew upgrade mokit 
```

```
brew update && brew upgrade mokit --fetch-HEAD
```

## Uninstall

```
brew uninstall mokit
```

Available programs are

- [mokit](https://gitlab.com/jxzou/mokit):
  Molecular Orbital KIT


## License

The package build files are available under a BSD-2-Clause license.

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).