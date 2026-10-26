#!/usr/bin/env bash
# Builds JotCove.app with ad-hoc signing by default.
# Set SIGN_ID explicitly to use your own code-signing identity.
set -euo pipefail
cd "$(dirname "$0")"

CONFIG="${CONFIG:-release}"
SIGN_ID="${SIGN_ID:--}"

# Each architecture needs its own build directory: some SwiftPM backends share
# their product path across triples and would otherwise overwrite the first slice.
if [ -n "${ARCHS:-}" ]; then
    SLICES=()
    for a in $ARCHS; do
        SCRATCH=".build/universal/$a"
        swift build -c "$CONFIG" --scratch-path "$SCRATCH" --triple "$a-apple-macosx"
        SLICE="$(swift build -c "$CONFIG" --scratch-path "$SCRATCH" --triple "$a-apple-macosx" --show-bin-path)/JotCove"
        lipo -verify_arch "$a" "$SLICE"
        SLICES+=("$SLICE")
    done
    mkdir -p build
    lipo -create "${SLICES[@]}" -output build/JotCove-universal
    BIN="build/JotCove-universal"
else
    swift build -c "$CONFIG"
    BIN="$(swift build -c "$CONFIG" --show-bin-path)/JotCove"
fi

APP="build/JotCove.app"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cp "$BIN" "$APP/Contents/MacOS/JotCove"
cp Resources/Info.plist "$APP/Contents/Info.plist"
[ -d Resources/Fonts ] && cp -R Resources/Fonts "$APP/Contents/Resources/Fonts"
[ -d Resources/Identity ] && cp -R Resources/Identity "$APP/Contents/Resources/Identity"
cp LICENSE "$APP/Contents/Resources/LICENSE"
cp THIRD_PARTY_NOTICES.md "$APP/Contents/Resources/THIRD_PARTY_NOTICES.md"
for f in AppIcon.icns Logo.png Pushpin.png MenuIcon.png MenuIcon@2x.png; do
    [ -f "Resources/$f" ] && cp "Resources/$f" "$APP/Contents/Resources/$f"
done

# Explicit signing identities get the hardened runtime and secure timestamp.
SIGN_FLAGS=()
if [ "$SIGN_ID" != "-" ]; then SIGN_FLAGS=(--options runtime --timestamp); fi
if ! codesign --force --sign "$SIGN_ID" ${SIGN_FLAGS[@]+"${SIGN_FLAGS[@]}"} --entitlements Resources/JotCove.entitlements "$APP" 2>/dev/null; then
    codesign --force --sign "$SIGN_ID" ${SIGN_FLAGS[@]+"${SIGN_FLAGS[@]}"} "$APP"
fi
echo "→ $APP (signed: $SIGN_ID)"
