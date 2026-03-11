# Homebrew Formula for Gravity-Lang
# To use this formula:
# 1. Create a tap: brew tap dill-lk/gravity-lang
# 2. Place this file in: homebrew-gravity-lang/Formula/gravity-lang.rb
# 3. Install: brew install gravity-lang

class GravityLang < Formula
  desc "Domain-specific language for gravitational physics simulations"
  homepage "https://github.com/dill-lk/Gravity-Lang"
  url "https://github.com/dill-lk/Gravity-Lang/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "REPLACE_WITH_ACTUAL_SHA256"
  license "MIT"
  head "https://github.com/dill-lk/Gravity-Lang.git", branch: "main"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build", "-j"

    bin.install "build/gravity"
    bin.install "build/gravityc"

    # Install examples
    (share/"gravity-lang").install "examples"

    # Install documentation
    doc.install "README.md"
    doc.install "CONTRIBUTING.md"
    doc.install "CHANGELOG.md"
  end

  test do
    # Test that binaries exist and run
    assert_match "Gravity-Lang", shell_output("#{bin}/gravity --help")
    assert_match "compiler", shell_output("#{bin}/gravityc --help")

    # Test a simple simulation
    (testpath/"test.gravity").write <<~EOS
      sphere Earth at [0,0,0][m] mass 5.972e24[kg] radius 6371[km] fixed
      sphere Moon at [384400,0,0][km] mass 7.348e22[kg] radius 1737[km]
      Moon.velocity = [0, 1.022, 0][km/s]

      simulate test in 0..10 dt 3600[s] integrator rk4 {
          grav all
      }
    EOS

    system bin/"gravity", "check", "test.gravity"
  end
end

# Installation instructions for users:
#
# Method 1: Using Homebrew tap (recommended)
# $ brew tap dill-lk/gravity-lang
# $ brew install gravity-lang
#
# Method 2: Direct install from URL
# $ brew install https://raw.githubusercontent.com/dill-lk/homebrew-gravity-lang/main/Formula/gravity-lang.rb
#
# Usage:
# $ gravity run /usr/local/share/gravity-lang/examples/moon_orbit.gravity
# $ gravityc --help
