# 本地开发、权限与打包

日期：2026-10-23。当前产品名保留 Pastory，Bundle ID 为 `local.pastory.app`，在线更新已移除。

## 运行权限

这些权限由使用者在自己的 Mac 上授予应用，与苹果开发者会员、签名证书和苹果公证分别处理。编写代码、编译和打包本身不需要这些运行权限。

| 权限 | 本项目的用途 | 不授权时 |
|---|---|---|
| 屏幕录制 | 截图和录屏时读取屏幕画面 | 截图、录屏被权限检查挡住；其他功能仍可使用 |
| 辅助功能 | 模拟 ⌘V，将卡片内容直接粘贴到前台应用 | 自动粘贴不可用；仍可复制后手动粘贴 |

代码入口：`Sources/Pastory/App/Permissions.swift`。应用设置页提供相应授权入口；屏幕录制授权后按提示退出并重新运行应用。

应用身份已变化，原身份的授权不保证继承。普通修改界面不代表每次必然重新授权，但临时签名、运行路径或运行产物改变时可能需要重新确认。Xcode Run 与完整 `.app` 可能对应不同的运行身份，应根据系统提示授权实际运行的程序。

## 添加设计元素与功能

- 色彩、字体、背景、纸张纹理、按钮：`Sources/Pastory/App/Theme.swift`。
- 侧栏、搜索、卡片区域：`Sources/Pastory/Shelf/ShelfView.swift`。
- 历史卡片与桌面便签：`ClipCardView.swift`、`DesktopNoteView.swift`。
- 设置与欢迎页：`SettingsPane.swift`、`WelcomeCard.swift`。
- 应用图标、Logo、菜单栏图标：`Resources/AppIcon.icns`、`Logo.png`、`MenuIcon.png`、`MenuIcon@2x.png`。
- 新的中英界面文字：同步维护 `Sources/Pastory/App/Localization.swift`。
- 新功能代码按职责放进 `App`、`Shelf`、`Capture`、`Clipboard` 或 `Annotate`。当前 SwiftPM target 包含 `Sources/Pastory` 下的源码。

新增图片资源时，除放进 Resources 外，还需把文件名加入 `build.sh` 的资源复制列表，并在界面代码中读取；仅将文件放入目录不会自动进入分发包。替换现有同名图片时，现有复制逻辑继续有效。

## 开发与完整应用验证

可以继续在 Xcode 中编辑、构建和运行。当前项目是 SwiftPM 可执行 target，`build.sh` 负责额外组装 Info.plist、图片、字体、LICENSE 与签名，生成完整 `.app`。

在项目根目录执行：

```bash
CONFIG=debug SIGN_ID=- ./build.sh
open build/Pastory.app
```

运行新包前先退出旧实例。验证安装行为、权限和资源显示时，使用完整 `.app`；不要把 Xcode 的可执行产物与安装后的应用混为同一个运行环境。

## 打包供他人安装

在项目根目录执行：

```bash
SIGN_ID=- NOTARY_PROFILE= ./dist.sh
```

这会使用 release 配置构建 arm64 + x86_64 的通用应用，临时签名并输出 `dist/Pastory-<版本>.zip` 及首次打开说明，不提交苹果公证、不发布到 GitHub。把 ZIP 发给别人，对方解压后将 App 拖入应用程序目录；未经公证时可能需要手动允许打开。

现有版本由 `Resources/Info.plist` 中的 `CFBundleShortVersionString`（展示版本）与 `CFBundleVersion`（构建号）控制。每次准备分发新版时按自己的版本策略更新，日常改界面无需每次调整。

若以后需要正式 Developer ID 签名和苹果公证，再显式配置自己的 `SIGN_ID` 与 `NOTARY_PROFILE`。当前本地开发和临时签名分发不要求付费开发者会员。
