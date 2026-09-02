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
  version "0.2.7"
  license :cannot_represent # Business Source License (BSL), converts to open after a distribution period; free to download and use, one-time commercial license at bodegaone.ai — see LICENSE

  on_macos do
    on_arm do
      url "https://github.com/BodegaoneAI/bodegaone-cli-releases/releases/download/v0.2.7/bodega-darwin-arm64.tar.gz"
      sha256 "1a14e18f8ae958d660c008f809170e3122715785ad8721a2bdad00858a38177e"
    end
    on_intel do
      url "https://github.com/BodegaoneAI/bodegaone-cli-releases/releases/download/v0.2.7/bodega-darwin-amd64.tar.gz"
      sha256 "b276106013c27601903da72c9289b585fb92c11eac7acc2df36f819b46e2cc46"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BodegaoneAI/bodegaone-cli-releases/releases/download/v0.2.7/bodega-linux-arm64.tar.gz"
      sha256 "df1ce80f194d45aeafa256b4137c8a7d106bfa05ff4a01306ee3537d44367f8e"
    end
    on_intel do
      url "https://github.com/BodegaoneAI/bodegaone-cli-releases/releases/download/v0.2.7/bodega-linux-amd64.tar.gz"
      sha256 "b2689e84a242f8240cc4b86cdb5157d4c9e0a75f35fd89e81c77fdbb43a17490"
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
