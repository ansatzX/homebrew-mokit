class Mokit < Formula
  desc "Molecular Orbital KIT"
  homepage "https://github.com/1234zou/MOKIT"
  url "https://gitlab.com/jxzou/mokit/-/archive/v1.2.6/mokit-v1.2.6.tar.gz"
  sha256 "6497ab45e4835a437d4fa770f72c5415531bdca22cfb8e7d99dd545b79fc27a9"
  version "1.2.6"
  license "Apache-2.0"
  head "https://github.com/1234zou/MOKIT", using: :git

  # Runtime dependencies: kept after install so mokit-compile-python can work
  depends_on "gcc"
  depends_on "openblas"
  depends_on "make"

  def install
    ENV.deparallelize

    # Generate platform Makefile for Homebrew (tarball has src/Makefile.main)
    openblas = Formula["openblas"].opt_lib
    (buildpath/"src/Makefile.brew").write <<~MAKEFILE
      BIN = ../bin
      LIB = ../mokit/lib
      USE_CONDA = true
      F90    = gfortran
      FFLAGS = -O2 -cpp -fPIC
      MKL_FLAGS = -L#{openblas} -lopenblas
      F2PY   = python3 -m numpy.f2py
      F2_FLAGS =
      F2_F90_FLAGS = --f90flags="-cpp"

      include Makefile.main
    MAKEFILE

    # Build executables only (no Python modules)
    cd "src" do
      system "make", "-f", "Makefile.brew", "exe"
    end

    # Install executables and the mokit Python package directory
    prefix.install "bin", "mokit"

    # Ensure mokit/lib directory exists for future .so files
    (prefix/"mokit/lib").mkpath

    # Save source files from tarball for later Python module compilation
    (pkgshare/"src").mkpath
    cp Dir["src/*.f90"], pkgshare/"src/"
    cp "src/Makefile.main", pkgshare/"src/"

    # Generate and install the mokit-compile-python script
    (bin/"mokit-compile-python").write compile_python_script
    (bin/"mokit-compile-python").chmod 0755
  end

  def caveats
    <<~EOS
      MOKIT executables are installed and ready to use.

      To set up your environment, add to your shell profile:
        export MOKIT_ROOT="$(brew --prefix mokit)"
        export PATH=$MOKIT_ROOT/bin:$PATH
        export LD_LIBRARY_PATH=$MOKIT_ROOT/mokit/lib:$LD_LIBRARY_PATH

      For Python modules (PySCF integration, etc.):
        1. Activate your Python environment (conda, uv, pyenv, etc.)
        2. Ensure numpy is installed: pip install numpy
        3. Run: mokit-compile-python
        4. Add to your shell profile:
             export PYTHONPATH=$MOKIT_ROOT:$PYTHONPATH

      Re-run mokit-compile-python after upgrading MOKIT or switching Python versions.
    EOS
  end

  test do
    assert_predicate bin/"automr", :exist?
    assert_predicate bin/"mokit-compile-python", :exist?
    assert_predicate share/"mokit/src/Makefile.main", :exist?
  end

  private

  def compile_python_script
    <<~'BASH'
    #!/bin/bash
    #
    # mokit-compile-python: Compile MOKIT Python modules for the active Python environment.
    #
    # Usage: Activate your Python environment (conda, uv, pyenv, etc.), then run:
    #   mokit-compile-python
    #
    # Prerequisites: numpy must be installed in the active Python environment.
    #
    set -euo pipefail

    # ── Resolve paths ────────────────────────────────────────────────────────

    HOMEBREW_PREFIX="$(brew --prefix)"
    MOKIT_PREFIX="$(brew --prefix mokit)"

    # Find gfortran from Homebrew's gcc
    GCC_OPT="$HOMEBREW_PREFIX/opt/gcc/bin"
    GFORTRAN=""
    if [ -d "$GCC_OPT" ]; then
        # Prefer versioned gfortran (e.g. gfortran-14), skip cross-compiler prefixes
        GFORTRAN="$(find "$GCC_OPT" -name 'gfortran-[0-9]*' -not -name '*-apple-*' 2>/dev/null | sort -V | tail -1)"
        # Fallback to unversioned symlink
        if [ -z "$GFORTRAN" ] && [ -x "$GCC_OPT/gfortran" ]; then
            GFORTRAN="$GCC_OPT/gfortran"
        fi
    fi
    if [ -z "$GFORTRAN" ]; then
        echo "Error: gfortran not found in $GCC_OPT" >&2
        echo "  Run: brew install gcc" >&2
        exit 1
    fi

    # OpenBLAS
    OPENBLAS_LIB="$HOMEBREW_PREFIX/opt/openblas/lib"
    if [ ! -d "$OPENBLAS_LIB" ]; then
        echo "Error: OpenBLAS not found at $OPENBLAS_LIB" >&2
        echo "  Run: brew install openblas" >&2
        exit 1
    fi

    # Python
    if ! command -v python3 &>/dev/null; then
        echo "Error: python3 not found in PATH." >&2
        echo "  Activate your Python environment before running this script." >&2
        exit 1
    fi

    if ! python3 -c "import numpy" 2>/dev/null; then
        echo "Error: numpy not found in the active Python environment." >&2
        echo "  Install it with: pip install numpy" >&2
        exit 1
    fi

    # Source files
    MOKIT_SRC="$MOKIT_PREFIX/share/mokit/src"
    if [ ! -d "$MOKIT_SRC" ]; then
        echo "Error: MOKIT source files not found at $MOKIT_SRC" >&2
        echo "  Reinstall MOKIT: brew reinstall mokit" >&2
        exit 1
    fi

    MOKIT_LIB="$MOKIT_PREFIX/mokit/lib"

    # ── Display configuration ────────────────────────────────────────────────

    PYTHON3="$(which python3)"
    PYTHON_VERSION="$(python3 --version 2>&1)"
    NUMPY_VERSION="$(python3 -c 'import numpy; print(numpy.__version__)')"

    echo "=== mokit-compile-python ==="
    echo "gfortran:    $GFORTRAN"
    echo "openblas:    $OPENBLAS_LIB"
    echo "python3:     $PYTHON3 ($PYTHON_VERSION)"
    echo "numpy:       $NUMPY_VERSION"
    echo "source dir:  $MOKIT_SRC"
    echo "output dir:  $MOKIT_LIB"
    echo ""

    # ── Build in temporary directory ─────────────────────────────────────────

    WORKDIR="$(mktemp -d)"
    trap 'rm -rf "$WORKDIR"' EXIT

    # Create directory structure expected by Makefile.main
    mkdir -p "$WORKDIR/src"
    mkdir -p "$WORKDIR/bin"
    mkdir -p "$WORKDIR/mokit/lib"

    # Copy source files
    cp "$MOKIT_SRC"/*.f90 "$WORKDIR/src/"
    cp "$MOKIT_SRC/Makefile.main" "$WORKDIR/src/"

    # Generate platform Makefile with absolute paths
    cat > "$WORKDIR/src/Makefile.gnu_openblas_macos" <<MAKEFILE
    BIN = ../bin
    LIB = ../mokit/lib
    USE_CONDA = true
    F90    = $GFORTRAN
    FFLAGS = -O2 -cpp -fPIC
    MKL_FLAGS = -L$OPENBLAS_LIB -lopenblas
    F2PY   = $PYTHON3 -m numpy.f2py
    F2_FLAGS = --f90exec=$GFORTRAN --f90flags="-cpp -I\$(CURDIR)"
    F2_F90_FLAGS =

    include Makefile.main
    MAKEFILE

    echo "Compiling Python modules (this may take a few minutes)..."
    echo ""

    cd "$WORKDIR/src"
    # Export FFLAGS so meson backend (numpy >= 2.0) picks up -cpp and -I for .mod files
    export FFLAGS="-O2 -cpp -fPIC -I$WORKDIR/src"
    export FCFLAGS="$FFLAGS"
    make -f Makefile.gnu_openblas_macos pymodules 2>&1

    # ── Install .so files ────────────────────────────────────────────────────

    echo ""
    echo "Removing old .so files from $MOKIT_LIB/"
    rm -f "$MOKIT_LIB"/*.so

    echo "Installing new .so files to $MOKIT_LIB/"
    cp "$WORKDIR/mokit/lib"/*.so "$MOKIT_LIB/"
    ls -la "$MOKIT_LIB"/*.so

    echo ""
    echo "=== Done! ==="
    echo "$PYTHON_VERSION modules installed."
    echo ""
    echo "Make sure your environment includes:"
    echo "  export MOKIT_ROOT=\"\$(brew --prefix mokit)\""
    echo "  export PYTHONPATH=\$MOKIT_ROOT:\$PYTHONPATH"
    BASH
  end
end
