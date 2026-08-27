# Homebrew formula for Bodega One Code.
#
# Tap usage (tap repo: https://github.com/BodegaoneAI/homebrew-bodega — live
# since v0.1.0; the release workflow pushes each stamped formula to it):
#   brew tap bodegaoneai/bodega
#   brew install bodega
#
# Homebrew is the clean macOS install path: `brew` strips the com.apple.quarantine
# attribute on install, so even an un-notarized bundle launches without a
# Gatekeeper block. The curl|sh path requires a notarized bundle.
#
# The downloaded artifact is the SAME per-(os,arch) bundle tarball the release
# workflow produces: it contains bin/bodega, a bundled Node runtime, and the
# backend payload. We install the whole bundle under libexec and symlink the
# binary into bin so the bundle's relative layout (runtime/, backend/) resolves.
#
# This committed file is a TEMPLATE: version "0.0.0" + the zeroed sha256
# placeholders below are replaced at publish time. On every tag the release
# workflow's finalize job stamps the real version + per-asset SHA-256 (from
# checksums.txt) and publishes the stamped bodega.rb as a release asset on
# BodegaoneAI/bodegaone-cli-releases — that stamped copy is the source of truth the
# homebrew-bodega tap consumes (the formula itself has no autoupdate block).
class Bodega < Formula
  desc "Local-first AI coding agent (TUI + headless) with bundled backend"
  homepage "https://github.com/Mayimbe07/Bodegaone-CLI"
  version "0.2.4"
  license :cannot_represent # Business Source License (BSL), converts to open after a distribution period; free to download and use, one-time commercial license at bodegaone.ai — see LICENSE

  on_macos do
    on_arm do
      url "https://github.com/BodegaoneAI/bodegaone-cli-releases/releases/download/v0.2.4/bodega-darwin-arm64.tar.gz"
      sha256 "bb991b723002146cb3feda7342917c937199fdb838306d145be5d1d91c0d6b06"
    end
    on_intel do
      url "https://github.com/BodegaoneAI/bodegaone-cli-releases/releases/download/v0.2.4/bodega-darwin-amd64.tar.gz"
      sha256 "2ac503c00d2a93f40e99ee862e5197578a9395d74f4e2bbe4f41df7397e652af"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BodegaoneAI/bodegaone-cli-releases/releases/download/v0.2.4/bodega-linux-arm64.tar.gz"
      sha256 "61cea15b3e71c18d4c20e768980571806ab1b6813ad570c007bda84b09028b65"
    end
    on_intel do
      url "https://github.com/BodegaoneAI/bodegaone-cli-releases/releases/download/v0.2.4/bodega-linux-amd64.tar.gz"
      sha256 "277efe368518adf2dfe0e8cb02f7f2d54ebbdd633e7f6bd36df9f02c25d36e99"
    end
  end

  def install
    # The tarball expands to the bundle root (bin/, runtime/, backend/, VERSION,
    # MANIFEST.json). Install the entire bundle under libexec so the binary keeps
    # its sibling runtime/ and backend/ payload, then expose the binary via bin.
    libexec.install Dir["*"]
    (libexec/"bin/bodega").chmod 0755
    bin.install_symlink libexec/"bin/bodega"
  end

  test do
    assert_match "bodega", shell_output("#{bin}/bodega --version")
  end
end
