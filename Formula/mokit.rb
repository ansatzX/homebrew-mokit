class Mokit < Formula
    desc "Molecular Orbital KIT"
    homepage "https://gitlab.com/jxzou/mokit"
    url "https://gitlab.com/jxzou/mokit/-/archive/v1.2.5/mokit-v1.2.5.tar.gz"
    sha256 "5ffa4df60f48cf4bec41ccde1b388f9440521d0ba07755f854c74df4414acf5d"
    version "v1.2.5-with-options"
    license " Apache License 2.0"
    head "https://gitlab.com/jxzou/mokit.git", branch: "master"
    
    option "with-py38", "interface between fortran and python@3.8"
    option "with-py39", "interface between fortran and python@3.9"
    option "with-py310", "interface between fortran and python@3.10"
    option "with-py311", "interface between fortran and python@3.11"

    on_macos do

        depends_on "gcc" => :build
        depends_on "gfortran" => :build
        depends_on "openblas" => :build
        depends_on "make" => :build
        depends_on "coreutils" => :build
        depends_on "binutils" => :build

        depends_on "python@3.8" if build.with? "py38"
        depends_on "python@3.9" if build.with? "py39"
        depends_on "python@3.10" if build.with? "py310"
        depends_on "python@3.11" if build.with? "py311"

        
      end
  
    def install
        if OS.mac? 
          ENV.deparallelize
          args = "exe"
          if build.with? "py38" or build.with? "py39" or build.with? "py310" or build.with? "py311"
            args = "all"
          end 

          system "pip3", "install", "numpy"

          cd "src" do
              if Hardware::CPU.arm?
                system "cp", "#{HOMEBREW_PREFIX}/Library/Taps/ansatzx/homebrew-mokit/tools/Makefile.gnu_openblas_macos",  "."
              end
              if Hardware::CPU.intel?
                system "cp", "#{HOMEBREW_PREFIX}/Homebrew/Library/Taps/ansatzx/homebrew-mokit/tools/Makefile.gnu_openblas_macos",  "."
              end
              # system "cp", "#{HOMEBREW_PREFIX}/Library/Taps/ansatzx/homebrew-mokit/tools/Makefile.main",  "."
              system "make", "-f", "Makefile.gnu_openblas_macos" , "#{args}"
          end
          prefix.install Dir["bin"]
          prefix.install Dir["mokit"]
        end
    end

    def caveats
        <<~EOS
          You need to take some manual steps in order to make this formula work:
            export MOKIT_ROOT="$(brew --prefix mokit)"
            export PATH=$MOKIT_ROOT/bin:$PATH
            export PYTHONPATH=$MOKIT_ROOT:$PYTHONPATH
            export LD_LIBRARY_PATH=$MOKIT_ROOT/mokit/lib:$LD_LIBRARY_PATH
        EOS
      end
  
    
  end
