class Mokit < Formula
  desc "Molecular Orbital KIT"
  homepage "https://github.com/1234zou/MOKIT"
  url "https://gitlab.com/jxzou/mokit/-/archive/v1.2.6/mokit-v1.2.6.tar.gz"
  sha256 "5ffa4df60f48cf4bec41ccde1b388f9440521d0ba07755f854c74df4414acf5d"
  version "1.2.6"
  license "Apache-2.0"
  head "https://github.com/1234zou/MOKIT", using: :git

  # Options for python versions
  option "with-py38", "Interface with python@3.8"
  option "with-py39", "Interface with python@3.9"
  option "with-py310", "Interface with python@3.10"
  option "with-py311", "Interface with python@3.11"
  option "with-py312", "Interface with python@3.12"

  # Build dependencies
  depends_on "gcc" => :build
  depends_on "gfortran" => :build
  depends_on "openblas" => :build
  depends_on "make" => :build
  depends_on "meson" => :build
  depends_on "virtualenv" => :build

  # Python dependencies based on options
  depends_on "python@3.8" => :optional
  depends_on "python@3.9" => :optional
  depends_on "python@3.10" => :optional
  depends_on "python@3.11" => :optional
  depends_on "python@3.12" => :optional

  # --- Numpy Wheel Resources ---
  # We use pre-compiled wheels to avoid long compilation times.
  # Resources are separated by CPU architecture.

  on_intel do
    # Numpy 1.26.0 for Python 3.8 on Intel macOS
    resource "numpy_py38_x86_64" do
      url "https://files.pythonhosted.org/packages/de/35/bf876c802456443f45357b79c491355a3f994a1b5353a38f61338855a250/numpy-1.26.0-cp38-cp38-macosx_11_0_x86_64.whl"
      sha256 "e368d9215b55242253805d245f0c882d2c4a3c2338b8a5a98239433b3f7775a3"
    end

    # Numpy 1.26.0 for Python 3.9 on Intel macOS
    resource "numpy_py39_x86_64" do
      url "https://files.pythonhosted.org/packages/a8/b4/2c3596b33b9b3ac35528c2a4605f59a24f6a5c5b341a6242a438f39d041c/numpy-1.26.0-cp39-cp39-macosx_11_0_x86_64.whl"
      sha256 "e33c191689233f62b934453a709525a4b881c430a6395a0f1e05c5a055b3a3e9"
    end

    # Numpy 1.26.0 for Python 3.10 on Intel macOS
    resource "numpy_py310_x86_64" do
      url "https://files.pythonhosted.org/packages/1f/c1/a2c3f3e83323b02a4ee942d2f45132ac30c69f3cc45006978c4c8025d5aa/numpy-1.26.0-cp310-cp310-macosx_11_0_x86_64.whl"
      sha256 "5bb336443a5955651341a289b54403a4a38e3570b4a26b54a6b34d68c075345c"
    end

    # Numpy 1.26.0 for Python 3.11 on Intel macOS
    resource "numpy_py311_x86_64" do
      url "https://files.pythonhosted.org/packages/b7/48/3c03a7d69a07ec8a5852cf2b83c0c5a3a9d5042544e6fec732b55e36586c/numpy-1.26.0-cp311-cp311-macosx_11_0_x86_64.whl"
      sha256 "b98deda0a8158054563435c1b83a9a01a17a246e5f6132f7d56f5b33bd934143"
    end

    # Numpy 1.26.0 for Python 3.12 on Intel macOS
    resource "numpy_py312_x86_64" do
      url "https://files.pythonhosted.org/packages/f1/6a/fe9f836e424f0b3d3f3fd9ac798ad9e4369b9997139a9f9c82f5b552a13c/numpy-1.26.0-cp312-cp312-macosx_11_0_x86_64.whl"
      sha256 "a3cf352a30c5b43b68e1f434b9c4e2065d182b1b85b625585c9d028db58a003a"
    end
  end

  on_arm do
    # NOTE: No numpy wheel for Python 3.8 on ARM for this version.

    # Numpy 1.26.0 for Python 3.9 on ARM macOS
    resource "numpy_py39_arm64" do
      url "https://files.pythonhosted.org/packages/3a/d2/5c0663133a425a94248a438f34d2453778bc663e6d727d9a31aa3143d74d/numpy-1.26.0-cp39-cp39-macosx_11_0_arm64.whl"
      sha256 "003a3c45f53968e582f35535a65e3a834b2bded54d69e4321c462f683b443349"
    end

    # Numpy 1.26.0 for Python 3.10 on ARM macOS
    resource "numpy_py310_arm64" do
      url "https://files.pythonhosted.org/packages/2c/34/215c47333b0bbfb3f4c45f4a1b333c2d23eb2d548e484a5c36f33bf2305a/numpy-1.26.0-cp310-cp310-macosx_12_0_arm64.whl"
      sha256 "9e1c714033e405341f01643330c0a836a369f08c3c0d04e3214a28f85c1d7a79"
    end

    # Numpy 1.26.0 for Python 3.11 on ARM macOS
    resource "numpy_py311_arm64" do
      url "https://files.pythonhosted.org/packages/a0/99/1afc3eade1778cca549ca0e7448ec5f6b9a3815e3ed3b24cea4245c1b06a/numpy-1.26.0-cp311-cp311-macosx_12_0_arm64.whl"
      sha256 "a4a97c6f72e05a6d682559b3f99a1052a0f940186a2234a5a2075d854b675d49"
    end

    # Numpy 1.26.0 for Python 3.12 on ARM macOS
    resource "numpy_py312_arm64" do
      url "https://files.pythonhosted.org/packages/a4/a7/a4a6c3f9a040016b0a49e604c0a445605de01b5b6d8841053a99f33f3fe3/numpy-1.26.0-cp312-cp312-macosx_12_0_arm64.whl"
      sha256 "3e991f47d9c0d673a16a31f6524f5b18941c22383f9dc60d495a81c820b37312"
    end
  end

  def install
    # Check for unsupported configurations
    if build.with?("py38") && Hardware::CPU.arm?
      odie "MOKIT with Python 3.8 is not supported on Apple Silicon (ARM) due to the lack of a pre-compiled numpy wheel."
    end

    # Determine if a python build is needed and which dependency to use
    py_build_opt = ARGV.options_only.find { |arg| arg.start_with?("--with-py") }
    py_build = py_build_opt.present?

    build_args = "exe"
    
    if py_build
      build_args = "all"
      py_version_num = py_build_opt.delete_prefix("--with-py") # "38", "39", etc.
      py_version_str = py_version_num.insert(1, ".") # "3.8", "3.9"
      py_dep = "python@#{py_version_str}"
      arch_str = Hardware::CPU.arch == :arm ? "arm64" : "x86_64"
      resource_name = "numpy_py#{py_version_num}_#{arch_str}"

      # Create a virtualenv
      venv_dir = buildpath/"venv"
      python_exec = Formula[py_dep].opt_bin/"python3"
      system "virtualenv", "--python=#{python_exec}", venv_dir
      
      # Set PATH to use the virtualenv's python and pip
      ENV.prepend_path "PATH", venv_dir/"bin"

      # Install the correct numpy wheel from resources
      resource(resource_name).stage do |res|
        system "pip", "install", res.glob("*.whl").first
      end
    end

    ENV.deparallelize
    pkgshare.install "tools"

    cd "src" do
      cp pkgshare/"tools/Makefile.gnu_openblas_macos", "."
      system "make", "-f", "Makefile.gnu_openblas_macos", build_args
    end

    prefix.install "bin", "mokit"
  end

  def caveats
    <<~EOS
      To use MOKIT, you need to set the following environment variables:
        export MOKIT_ROOT="$(brew --prefix mokit)"
        export PATH=$MOKIT_ROOT/bin:$PATH
        export PYTHONPATH=$MOKIT_ROOT:$PYTHONPATH
        export LD_LIBRARY_PATH=$MOKIT_ROOT/mokit/lib:$LD_LIBRARY_PATH
    EOS
  end

  test do
    system "#{bin}/mokit", "--help"
  end
end