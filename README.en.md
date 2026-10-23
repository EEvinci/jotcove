<p align="center"><img src="Resources/Logo.png" width="88" alt="Pastory"></p>
<h1 align="center">Pastory</h1>
<p align="center">Keep inspiration close.</p>
<p align="center">Developed and maintained by Evinci · Clipboard and capture for macOS</p>
<p align="center"><a href="README.md">简体中文</a> · English</p>

<p align="center"><img src="docs/images/hero-en.png" alt="Pastory clipboard" width="100%"></p>

Pastory keeps copied text, links, images, files and recordings on your Mac, ready to search and reuse. Cocoa brown, mist blue, warm greige and a personal character bring a stationery feel to the workspace.

## Features

- Clipboard history with filters, full-text search, titles, editing and pinned favorites.
- Click to copy, double-click to paste into the previous app, or navigate with the keyboard.
- Screenshots, shapes, arrows, drawing, text, mosaic and local OCR.
- Region recording with MP4 and GIF export.
- Desktop notes: drag a card up and out of the shelf to keep it on the desktop.
- Local storage with no account required.

## Installation

Requires macOS 15 or later. Unzip the package, drag `Pastory.app` into Applications, and open it. Click its menu bar icon to show the clipboard.

Default shortcuts: ⇧⌘V for the clipboard, ⌥⌘S for screenshots and recordings, and ⌥⌘F for search. Change them in Settings.

Screen capture requires Screen Recording permission. Direct pasting requires Accessibility permission. Check the included first-launch instructions for the package's signing and notarization status.

## Data

Data stays in `~/Library/Application Support/Pastory/` as a SQLite index and content files. Pinned items are excluded from automatic cleanup. Other items follow your retention settings. There are no online update checks or clipboard uploads.

## Development and packaging

For Xcode development, open `Pastory.xcodeproj`, select the `Pastory` scheme and `My Mac`, then run. This target builds a complete `.app` with bundle metadata and resources. Opening `Package.swift` directly runs a SwiftPM executable target rather than the native app target.

```bash
./build.sh                 # Current architecture → build/Pastory.app
./dist.sh                  # Intel + Apple silicon package
./release.sh notes.md      # Prepare package and release notes
```

Use your own `SIGN_ID` and `NOTARY_PROFILE` for signing and notarization. Scripts generate local artifacts.

Repository: [EEvinci/pastory](https://github.com/EEvinci/pastory). See [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md) for development conventions.

## Open-source licenses

See [LICENSE](LICENSE) and [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for license and component notices.
