class SynaxiBeta < Formula
  desc "Beta local runtime for AI coding-tool requests"
  homepage "https://synaxi.ai"
  version "0.14.0-beta.2"
  license :cannot_represent

  conflicts_with "synaxi", because: "the beta installs the same synaxi executable"

  on_macos do
    on_arm do
      url "https://synaxi.ai/releases/synaxi-#{version}-darwin-arm64.tar.gz"
      sha256 "195ec3b32401e8796088c501f619f369e172d5c1427857763dc8ba4c798b43b6"
    end
    on_intel do
      url "https://synaxi.ai/releases/synaxi-#{version}-darwin-amd64.tar.gz"
      sha256 "5f0af13c5341cc2f7cb4d6a53eb67bdd90d39aca76ac64cd3e646833577e920a"
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
