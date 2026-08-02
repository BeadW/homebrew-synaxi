# Homebrew formula for the Synaxi CLI runtime (`synaxi wrap claude`).
# docs/implementation-plan-target-architecture.md. This formula positions this
# repository as its own tap:
#
#   brew tap BeadW/synaxi
#   brew install synaxi
#
# or, without a separate tap step:
#
#   brew install BeadW/synaxi/synaxi
#
# .github/workflows/release.yml builds, codesigns/notarises (macOS only),
# packages, and uploads the archives this formula points at, on every tag
# push (beta and stable) — see the "CLI bootstrap archives" steps added in
# the v0.11.0 PR. The archive layout convention used here:
# synaxi-<version>-<os>-<arch>.tar.gz contains the single `synaxi` binary.
#
# URLs point at synaxi.ai (S3 bucket synaxi-ai-landing, fronted by
# CloudFront distribution E1I4I3C3LJE3M), NOT github.com/BeadW/synaxi/
# releases/download/... — BeadW/synaxi is a private repo, and a private
# repo's browser_download_url 404s for any unauthenticated fetch (confirmed
# empirically: plain curl gets 404, `gh`/the GitHub API gets a 302 to a
# signed blob URL only because it's authenticated). Homebrew has no
# supported way to make `brew install` work for the general public against
# a private repo's releases without every installing user having their own
# token with read access to that repo, which defeats the purpose for a
# public product. The fix (same pattern 1Password CLI and ngrok use, and
# the same one Synaxi's own macOS DMGs already use — see release.yml's
# "Upload to S3" / "Invalidate CloudFront" steps): serve the archives from
# Synaxi's own CDN instead, where Homebrew's `url` directive only cares
# that the host is anonymously fetchable and the sha256 matches.
class Synaxi < Formula
  desc "Local runtime that optimises AI coding-tool requests on your machine"
  homepage "https://synaxi.ai"
  version "0.12.0"
  license :cannot_represent # see LICENSE — source-available, proprietary, not an OSI/SPDX id

  on_macos do
    on_arm do
      url "https://synaxi.ai/releases/synaxi-#{version}-darwin-arm64.tar.gz"
      sha256 "7fc03dbd5e9b591c385b8a36f5e5be29dbbc1cea8269943c79c15eb09ee5f459"
    end
    on_intel do
      url "https://synaxi.ai/releases/synaxi-#{version}-darwin-amd64.tar.gz"
      sha256 "c3d48a2f1962f451be1773a473b0e7bbec8042b83341e4bd626263a95a8fe140"
    end
  end

  def install
    bin.install "synaxi"
  end

  def caveats
    <<~EOS
      Get started:
        synaxi wrap claude      # runs Claude Code routed through the local runtime,
                                 # for that session only

      Synaxi runs entirely on this machine and talks directly to your model
      provider —
      installing it does not start any background process, and
      nothing you send to your model provider passes through a Synaxi-operated
      server.
    EOS
  end

  test do
    assert_match "usage: synaxi wrap claude", shell_output("#{bin}/synaxi wrap 2>&1", 2)
  end
end
