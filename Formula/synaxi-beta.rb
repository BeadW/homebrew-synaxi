class SynaxiBeta < Formula
  desc "Beta local runtime for AI coding-tool requests"
  homepage "https://synaxi.ai"
  version "0.13.0-beta.5"
  license :cannot_represent

  conflicts_with "synaxi", because: "the beta installs the same synaxi executable"

  on_macos do
    on_arm do
      url "https://synaxi.ai/releases/synaxi-#{version}-darwin-arm64.tar.gz"
      sha256 "343fd49d0448eaa373973c92b31bf0d2123a39b40f1f86df5ed32b13b7a4318a"
    end
    on_intel do
      url "https://synaxi.ai/releases/synaxi-#{version}-darwin-amd64.tar.gz"
      sha256 "f5207b5595a3575b8d26f580e283c53bb85e58e2293fd3c6699d8c16fa39258a"
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
