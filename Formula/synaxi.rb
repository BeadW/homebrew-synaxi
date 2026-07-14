# Homebrew formula for the Synaxi CLI runtime (`synaxi`, `synaxi wrap`,
# `synaxi dashboard`) — the package-manager install path from Workstream 8 of
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
# synaxi-<version>-<os>-<arch>.tar.gz, each containing two files at its
# root, `synaxi` and `synaxi-edge` (no wrapping directory) — chosen to
# match the flat `bin.install` calls below.
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
#
# The sha256 values below are still REPLACE_WITH_SHA256_<PLATFORM>:
# this PR wires up publishing but does not fabricate hashes for a release
# that hasn't actually run through CI's real signing/notarization
# credentials yet. Once v0.11.0-beta.1 (or whichever tag is cut first with
# this workflow) finishes, release.yml prints each archive's real sha256 in
# the GitHub Release notes (see the "Compute bootstrap archive checksums"
# step) — copy those values in here by hand. A small templating step that
# auto-commits them back was considered and deliberately deferred (see the
# PR body) rather than adding release-time repo-write permissions for a
# first pass.
class Synaxi < Formula
  desc "Local runtime that optimises and routes Claude Code traffic on your machine"
  homepage "https://synaxi.ai"
  version "0.11.0-beta.1"
  license :cannot_represent # see LICENSE — source-available, proprietary, not an OSI/SPDX id

  on_macos do
    on_arm do
      url "https://synaxi.ai/releases/synaxi-#{version}-darwin-arm64.tar.gz"
      sha256 "REPLACE_WITH_SHA256_DARWIN_ARM64"
    end
    on_intel do
      url "https://synaxi.ai/releases/synaxi-#{version}-darwin-amd64.tar.gz"
      sha256 "REPLACE_WITH_SHA256_DARWIN_AMD64"
    end
  end

  on_linux do
    on_arm do
      url "https://synaxi.ai/releases/synaxi-#{version}-linux-arm64.tar.gz"
      sha256 "REPLACE_WITH_SHA256_LINUX_ARM64"
    end
    on_intel do
      url "https://synaxi.ai/releases/synaxi-#{version}-linux-amd64.tar.gz"
      sha256 "REPLACE_WITH_SHA256_LINUX_AMD64"
    end
  end

  def install
    bin.install "synaxi"
    bin.install "synaxi-edge"
  end

  def caveats
    <<~EOS
      Get started:
        synaxi setup            # adds `synaxi` and a `claude` alias to your shell
        synaxi wrap claude      # runs Claude Code routed through the local runtime,
                                 # for that session only

      Once synaxi is running, view savings and settings with:
        synaxi dashboard        # opens the local dashboard in your browser

      Synaxi runs entirely on this machine and talks directly to Anthropic or
      Bedrock — installing it does not start any background process, and
      nothing you send to Claude passes through a Synaxi-operated server.
    EOS
  end

  test do
    # `claude-plugin status` is local-only (reads files under ~/.synaxi and
    # checks PATH for a claude binary) — no network call, no account, no
    # daemon needed, so it's exit-0 in a bare CI sandbox. This just asserts
    # the installed binary runs and exits cleanly; it is not a smoke test of
    # daemon/auth behaviour, which needs a real account to validate.
    system "#{bin}/synaxi", "claude-plugin", "status", "--json"
  end
end
