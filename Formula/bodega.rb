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
  version "0.2.5"
  license :cannot_represent # Business Source License (BSL), converts to open after a distribution period; free to download and use, one-time commercial license at bodegaone.ai — see LICENSE

  on_macos do
    on_arm do
      url "https://github.com/BodegaoneAI/bodegaone-cli-releases/releases/download/v0.2.5/bodega-darwin-arm64.tar.gz"
      sha256 "3bcccc2840055046c4a9b96e183342cb54784613bd330792854cda7e85b5d5e3"
    end
    on_intel do
      url "https://github.com/BodegaoneAI/bodegaone-cli-releases/releases/download/v0.2.5/bodega-darwin-amd64.tar.gz"
      sha256 "3a01c137b7a571338afc6cba16d0b9ca44ce08031bcf4e3a558a5fa85c480043"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BodegaoneAI/bodegaone-cli-releases/releases/download/v0.2.5/bodega-linux-arm64.tar.gz"
      sha256 "69adc53ebc7335b2aa1225f78202f0412d420758ce534123d196aa4e041fd966"
    end
    on_intel do
      url "https://github.com/BodegaoneAI/bodegaone-cli-releases/releases/download/v0.2.5/bodega-linux-amd64.tar.gz"
      sha256 "c8c7f49de07534e10cf41223ebe4fa693804203dcbda8396f240aa28b51d18f6"
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
