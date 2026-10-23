#!/usr/bin/env bash
# Prepare a local release package and optional release notes. No remote publishing.
set -euo pipefail
cd "$(dirname "$0")"
VERSION="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' Resources/Info.plist)"
NOTES="${1:-}"
if [ -n "$NOTES" ] && [ ! -f "$NOTES" ]; then
    echo "Release notes file does not exist: $NOTES" >&2
    exit 2
fi
./dist.sh
if [ -n "$NOTES" ]; then cp "$NOTES" "dist/Pastory-$VERSION-notes.md"; fi
echo "Local release prepared in dist/."
