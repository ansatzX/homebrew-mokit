class Mokit < Formula
  desc "Molecular Orbital KIT"
  homepage "https://github.com/1234zou/MOKIT"
  url "https://gitlab.com/jxzou/mokit/-/archive/v1.2.7/mokit-v1.2.7.tar.gz"
  version "1.2.7"
  sha256 "f469123b1ef744682518218e4faa76e22094986058fc8ec073ccd125e29e7be3"
  license "Apache-2.0"
  head "https://git.nju.edu.cn/jxzou/mokit", using: :git

  depends_on "gcc"
  depends_on "make"
  depends_on "openblas"
  depends_on "uv"

  def install
    ENV.deparallelize

    # Generate platform Makefile for Homebrew
    openblas = Formula["openblas"].opt_lib
    (buildpath/"src/Makefile.brew").write <<~MAKEFILE
      BIN = ../bin
      LIB = ../mokit/lib
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

    # ---- pkgshare before prefix.install (which moves files) ----
    # Fortran sources + Makefile
    (pkgshare/"src").mkpath
    cp Dir["src/*.f90"], pkgshare/"src/"
    cp "src/Makefile.main", pkgshare/"src/"

    # Python packaging files -- pyproject.toml must exist
    cp "pyproject.toml", pkgshare
    ["setup.cfg", "MANIFEST.in"].each do |f|
      cp f, pkgshare if File.exist?(f)
    end

    # mokit/ Python package -- copy to pkgshare before prefix.install moves it
    cp_r "mokit", pkgshare

    # Install executables and mokit to Cellar
    prefix.install "bin", "mokit"

    # Ensure mokit/lib directory exists for future .so files
    (prefix/"mokit/lib").mkpath

    # Install the mokit-compile-python script from tap tools directory
    script_path = File.expand_path("../tools/mokit-compile-python", __dir__)
    cp script_path, (bin/"mokit-compile-python")
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

      The Python modules install as a regular package -- no PYTHONPATH needed.
      Re-run mokit-compile-python after upgrading MOKIT or switching Python.
    EOS
  end

  test do
    # Static assertions
    assert_path_exists bin/"automr"
    assert_path_exists bin/"mokit-compile-python"
    assert_path_exists pkgshare/"src/Makefile.main"
    assert_path_exists pkgshare/"pyproject.toml"

    # Integration test: uv venv -> numpy -> mokit-compile-python -> import
    testdir = Pathname.new(Dir.mktmpdir("mokit-test-"))
    ENV["UV_CACHE_DIR"] = (testdir/".cache/uv").to_s
    ENV["PIP_NO_INPUT"] = "1"

    python_version = "3.12"
    system "uv", "venv", "--python", python_version, "--seed", (testdir/"venv").to_s
    system (testdir/"venv/bin/python").to_s, "-m", "pip", "install", "numpy"
    ENV["PATH"] = "#{testdir}/venv/bin:#{ENV["PATH"]}"
    system bin/"mokit-compile-python"
    system (testdir/"venv/bin/python").to_s, "-c", "import mokit"
  ensure
    testdir&.rmtree
  end
end
