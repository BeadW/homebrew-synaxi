class SynaxiBeta < Formula
  desc "Beta local runtime for AI coding-tool requests"
  homepage "https://synaxi.ai"
  version "0.13.0-beta.10"
  license :cannot_represent

  conflicts_with "synaxi", because: "the beta installs the same synaxi executable"

  on_macos do
    on_arm do
      url "https://synaxi.ai/releases/synaxi-#{version}-darwin-arm64.tar.gz"
      sha256 "d49d2622366e43c9343e6156dcdfbf83e6fff43ced592f1c8eb10a167d0d47cf"
    end
    on_intel do
      url "https://synaxi.ai/releases/synaxi-#{version}-darwin-amd64.tar.gz"
      sha256 "10d633f47b70b79a08f84218504294c11cfdad5f19ac7fb1f4d3708104e92626"
    end
  end

  def install
    bin.install "synaxi"
  end

  def caveats
    <<~EOS
      This is a beta transport adapter for Codex.

      Start Codex with:
        synaxi wrap codex

      To capture local request fixtures for adapter development:
        SYNAXI_CAPTURE_DIR="$HOME/.synaxi/codex-captures" synaxi wrap codex

      Captures may contain prompts and source code. Keep them local and delete
      them when no longer needed.
    EOS
  end

  test do
    assert_match "usage: synaxi wrap", shell_output("#{bin}/synaxi wrap 2>&1", 2)
  end
end
