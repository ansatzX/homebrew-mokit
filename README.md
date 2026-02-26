# AnsatzX Mokit_brew

This repository provides Homebrew package build instructions for [MOKIT](https://github.com/1234zou/MOKIT) (Molecular Orbital KIT).

## Installation

### Step 1: Install MOKIT

```
brew tap ansatzx/homebrew-mokit
brew install mokit
```

Or in one command:

```
brew install ansatzx/homebrew-mokit/mokit
```

### Step 2: Set up environment

Add to your `~/.zshrc` or `~/.bashrc`:

```bash
export MOKIT_ROOT="$(brew --prefix mokit)"
export PATH=$MOKIT_ROOT/bin:$PATH
export LD_LIBRARY_PATH=$MOKIT_ROOT/mokit/lib:$LD_LIBRARY_PATH
```

### Step 3 (Optional): Compile Python modules

If you need MOKIT's Python modules (for PySCF integration, etc.):

1. Activate your Python environment (conda, uv, pyenv, Homebrew python, etc.)
2. Ensure numpy is installed: `pip install numpy`
3. Run:

```
mokit-compile-python
```

4. Add to your shell profile:

```bash
export PYTHONPATH=$MOKIT_ROOT:$PYTHONPATH
```

The Python modules are compiled against your active Python environment.
If you switch Python versions, re-run `mokit-compile-python`.

### Install latest Git version (HEAD)

```
brew install ansatzx/homebrew-mokit/mokit --HEAD
```

## Update

```
brew update && brew upgrade mokit
```

After upgrading, re-run `mokit-compile-python` if you use Python modules.

## Uninstall

```
brew uninstall mokit
```

## License

The package build files are available under a BSD-2-Clause license.

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).
