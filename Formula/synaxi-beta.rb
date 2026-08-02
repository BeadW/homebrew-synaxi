class SynaxiBeta < Formula
  desc "Beta local runtime for AI coding-tool requests"
  homepage "https://synaxi.ai"
  version "0.13.0-beta.4"
  license :cannot_represent

  conflicts_with "synaxi", because: "the beta installs the same synaxi executable"

  on_macos do
    on_arm do
      url "https://synaxi.ai/releases/synaxi-#{version}-darwin-arm64.tar.gz"
      sha256 "acd8a65d3a6fd784c9c5f2637cee5c7d1e659182ccc2d951de25a1f988899e42"
    end
    on_intel do
      url "https://synaxi.ai/releases/synaxi-#{version}-darwin-amd64.tar.gz"
      sha256 "66c74c4dc08eb5c85e8ec75f8da20b4cec4d9955875fa35268490258215e6820"
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
