# homebrew-mokit

Homebrew formula for [MOKIT](https://github.com/1234zou/MOKIT) (Molecular Orbital KIT).

## Install

```bash
brew tap ansatzx/mokit
brew install mokit
```

Dependencies: `gcc`, `make`, `openblas`, `uv`.

## Environment

Add to `~/.zshrc` or `~/.bashrc`:

```bash
export MOKIT_ROOT="$(brew --prefix mokit)"
export PATH="$MOKIT_ROOT/bin:$PATH"
export LD_LIBRARY_PATH="$MOKIT_ROOT/mokit/lib:$LD_LIBRARY_PATH"
```

## Python modules

`mokit-compile-python` builds and installs the Python package into your active environment (via `pip install .`). No `PYTHONPATH` needed.

```bash
# activate your Python environment, then:
pip install numpy
mokit-compile-python
```

Three invocation modes:

```bash
mokit-compile-python                              # use python3 from PATH
mokit-compile-python --python 3.12                # auto-create uv venv
mokit-compile-python --python /path/to/venv/bin/python  # explicit interpreter
```

Re-run after upgrading MOKIT or switching Python versions.

## Update

```bash
brew upgrade mokit
```

## Uninstall

```bash
brew uninstall mokit
brew untap ansatzx/mokit
```
