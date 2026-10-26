#!/usr/bin/env bash
# Build a Universal distribution with instructions and SHA-256 checksums.
# Signing and notarization use only explicitly supplied credentials.
set -euo pipefail
cd "$(dirname "$0")"
SIGN_ID="${SIGN_ID:--}"
NOTARY_PROFILE="${NOTARY_PROFILE:-}"
NOTARIZED=0
if [ -n "$NOTARY_PROFILE" ] && [ "$SIGN_ID" = "-" ]; then
    echo "Set SIGN_ID to your Developer ID identity before requesting notarization." >&2
    exit 2
fi
ARCHS="arm64 x86_64" SIGN_ID="$SIGN_ID" ./build.sh
APP="$PWD/build/JotCove.app"
VERSION="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$APP/Contents/Info.plist")"
mkdir -p dist
ARCHIVE="$PWD/dist/JotCove-$VERSION.zip"
if [ -n "$NOTARY_PROFILE" ]; then
    # Submit the app first; the final archive is assembled after stapling.
    ditto -c -k --sequesterRsrc --keepParent "$APP" "$ARCHIVE"
    xcrun notarytool submit "$ARCHIVE" --keychain-profile "$NOTARY_PROFILE" --wait
    xcrun stapler staple "$APP"
    spctl --assess --type execute -vv "$APP"
    NOTARIZED=1
fi
codesign --verify --deep --strict "$APP"

if [ "$NOTARIZED" = "1" ]; then
    OPEN_ZH="本次安装包已完成 Apple 公证。双击打开，按系统提示确认即可。"
    OPEN_EN="This package has been notarized by Apple. Open it and confirm the system prompt."
else
    OPEN_ZH="本次安装包未经 Apple 公证。如 macOS 阻止打开，请到「系统设置 → 隐私与安全性」找到 JotCove，选择「仍要打开」，再按系统提示确认。"
    OPEN_EN="This package is not notarized by Apple. If macOS blocks it, go to System Settings → Privacy & Security, choose Open Anyway for JotCove, and confirm the system prompt."
fi
cat > dist/FIRST-LAUNCH.txt <<EOF
JotCove $VERSION · 首次打开
由 Evinci 开发与维护。

支持 macOS 15 或更新版本；同一个安装包支持 Apple 芯片与 Intel。

1. 先退出旧版 JotCove，解压后把 JotCove.app 拖入「应用程序」。
2. $OPEN_ZH
3. 打开后点击菜单栏的图标，或按 ⇧⌘V 显示剪贴板。完成欢迎引导后，应用不会每次自动弹出主窗口。
4. 首次截图/录屏时授予屏幕录制权限，并按提示重新启动 JotCove。
5. 双击直接粘贴需要辅助功能权限；未授权时仍可单击复制，再自行粘贴。
6. 快捷键可在设置中更改：⇧⌘V 剪贴板，⌥⌘S 截图/录屏，⌥⌘F 搜索。

数据在 ~/Library/Application Support/Pastory/，没有云同步、在线更新检查或剪贴板上传。
升级前备份历史：先退出应用，再复制整个数据目录。不要同时运行多个实例操作同一目录。
当前录屏不包含系统声音与麦克风声音。

项目与更新：https://github.com/EEvinci/jotcove
下载：https://github.com/EEvinci/jotcove/releases/latest

------------------------------------------------------------
JotCove $VERSION · First launch
Developed and maintained by Evinci.

Requires macOS 15 or later. One Universal app supports Apple silicon and Intel.

1. Quit any old JotCove instance. Unzip and drag JotCove.app into Applications.
2. $OPEN_EN
3. Click its menu bar icon or press ⇧⌘V to show the clipboard. After onboarding, no main window opens automatically on every launch.
4. Grant Screen Recording permission when first capturing or recording, then relaunch when prompted.
5. Direct pasting needs Accessibility permission. Without it, click to copy and paste manually.
6. Change shortcuts in Settings: ⇧⌘V clipboard, ⌥⌘S capture/record, ⌥⌘F search.

Data stays in ~/Library/Application Support/Pastory/. No cloud sync, update checks or clipboard uploads.
Quit before backing up the entire data directory. Do not run multiple instances against the same directory.
Recordings currently contain no system or microphone audio.

Project: https://github.com/EEvinci/jotcove
Downloads: https://github.com/EEvinci/jotcove/releases/latest
EOF

STAGE="$(mktemp -d "$PWD/dist/package.XXXXXX")"
trap 'rm -rf "$STAGE"' EXIT
ditto "$APP" "$STAGE/JotCove.app"
cp dist/FIRST-LAUNCH.txt "$STAGE/FIRST-LAUNCH.txt"
rm -f "$ARCHIVE"
(cd "$STAGE" && ditto -c -k --sequesterRsrc . "$ARCHIVE")
(cd dist && shasum -a 256 "JotCove-$VERSION.zip" FIRST-LAUNCH.txt > SHA256SUMS.txt)
echo "→ $ARCHIVE"
echo "→ dist/FIRST-LAUNCH.txt + dist/SHA256SUMS.txt"
