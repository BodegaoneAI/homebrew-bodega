# Bodega One Code — Homebrew Tap

The macOS / Linux install path for [Bodega One Code](https://bodegaone.ai), the
local-first AI coding agent (TUI + headless).

```sh
brew tap bodegaoneai/bodega
brew install bodega
```

Then:

```sh
bodega doctor   # verify the install
bodega          # start the TUI
```

Homebrew strips the `com.apple.quarantine` attribute on install, so the bundle
launches without a Gatekeeper block. The formula installs the full bundle
(binary + pinned Node runtime + backend payload) under `libexec` — no system
Node required.

The formula is stamped by the release pipeline on every tag; checksums come
from the release's `checksums.txt` on
[bodegaone-cli-releases](https://github.com/BodegaoneAI/bodegaone-cli-releases).
