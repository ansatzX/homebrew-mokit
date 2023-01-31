class Mokit < Formula
    desc "Molecular Orbital KIT"
    homepage "https://gitlab.com/jxzou/mokit"
    url "https://gitlab.com/jxzou/mokit/-/archive/v1.2.4/mokit-v1.2.4.tar.gz"
    sha256 "15b99d0f84e7635e62ca28cd72c26ad7a06fe2d3957c740839e9a6a8af72a1d2"
    license " Apache License 2.0"

    head "https://gitlab.com/jxzou/mokit.git", branch: "master"
  
    on_macos do
        on_arm do
            depends_on "gcc" => :build
            depends_on "gfortran" => :build
            depends_on "openblas" => :build
            # depends_on "miniconda" => :build
            depends_on "make" => :build
        end
      end
  
    def install
        ENV.deparallelize
        cd "src" do
            system "cp", "#{HOMEBREW_PREFIX}/Library/Taps/ansatzx/homebrew-mokit/tools/Makefile.gnu_openblas_macos",  "."
            system "cp", "#{HOMEBREW_PREFIX}/Library/Taps/ansatzx/homebrew-mokit/tools/Makefile.main",  "."
            system "make", "-f", "Makefile.gnu_openblas_macos", "all"
        end
        prefix.install Dir["bin/*"]
    end

    def caveats
        <<~EOS
          You need to take some manual steps in order to make this formula work:
            export PATH=$PATH:"$(brew --prefix)/Cellar/mokit/1.2.4"
        EOS
      end
  
    
  end
