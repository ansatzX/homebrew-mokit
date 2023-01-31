class Mokit < Formula
    desc "Molecular Orbital KIT"
    homepage "https://gitlab.com/jxzou/mokit"
    url "https://gitlab.com/jxzou/mokit/-/archive/master/mokit-master.tar.gz"
    sha256 "328fec4d07ea84782c9ecf8f2f9ae9f1e38750450e34035301494c62a44ebcc3"
    version "master"
    license " Apache License 2.0"

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
        prefix.install Dir["bin"]
        prefix.install Dir["mokit"]
    end

    def caveats
        <<~EOS
          You need to take some manual steps in order to make this formula work:
            export PATH=$PATH:"$(brew --prefix)/Cellar/mokit/1.2.4"
        EOS
      end
  
    
  end
