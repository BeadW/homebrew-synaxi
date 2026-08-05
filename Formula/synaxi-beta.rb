class SynaxiBeta < Formula
  desc "Beta local runtime for AI coding-tool requests"
  homepage "https://synaxi.ai"
  version "0.13.0-beta.30"
  license :cannot_represent

  conflicts_with "synaxi", because: "the beta installs the same synaxi executable"

  on_macos do
    on_arm do
      url "https://synaxi.ai/releases/synaxi-#{version}-darwin-arm64.tar.gz"
      sha256 "5326e8e3e57366d07c02539516835508ce9e379b0789a7249d1910192fbe395d"
    end
    on_intel do
      url "https://synaxi.ai/releases/synaxi-#{version}-darwin-amd64.tar.gz"
      sha256 "b5db4c63396c02f557d34caccc3cb3d16c6d0ec1af3dd161997911422b91698f"
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
