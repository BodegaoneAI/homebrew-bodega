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
  version "0.1.2"
  license :cannot_represent # proprietary (free to use, commercial license required)

  on_macos do
    on_arm do
      url "https://github.com/BodegaoneAI/bodegaone-cli-releases/releases/download/v0.1.2/bodega-darwin-arm64.tar.gz"
      sha256 "860a4fa49f73b5704afcbf48af5e15bbf411e57999cfa3969ce3116a1963f5f6"
    end
    on_intel do
      url "https://github.com/BodegaoneAI/bodegaone-cli-releases/releases/download/v0.1.2/bodega-darwin-amd64.tar.gz"
      sha256 "e62d24574c6938d56a9835fe55dc9155e3d898b57c5d41cbde915c3543ab9d5b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BodegaoneAI/bodegaone-cli-releases/releases/download/v0.1.2/bodega-linux-arm64.tar.gz"
      sha256 "8229fa4c265d1b88f54ead1b09f4449e83a724f224291f1d463864ce2aa6fc02"
    end
    on_intel do
      url "https://github.com/BodegaoneAI/bodegaone-cli-releases/releases/download/v0.1.2/bodega-linux-amd64.tar.gz"
      sha256 "b5765c01d2ce4d7db58d183e63ebd139ea8b62072a5cb520662717709701201c"
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
