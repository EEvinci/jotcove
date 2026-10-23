<p align="center"><img src="Resources/Logo.png" width="88" alt="Pastory"></p>
<h1 align="center">Pastory</h1>
<p align="center">灵感，留在手边。</p>
<p align="center">Evinci 开发与维护 · macOS 剪贴板与截图工具</p>
<p align="center">简体中文 · <a href="README.en.md">English</a></p>

<p align="center"><img src="docs/images/hero-zh.png" alt="Pastory 剪贴板" width="100%"></p>

Pastory 将复制过的文本、链接、图片、文件和录屏保存在本机，随时搜索和再次使用。可可棕、雾霾蓝与米灰构成界面主色，人物形象与文具式卡片让工作空间更有温度。

## 功能

- 剪贴板历史：按类型浏览、全文搜索、命名、编辑和 Pin 收藏。
- 快速复用：单击复制，双击直接粘贴到刚才的应用；支持键盘选择。
- 截图与标注：矩形、圆、箭头、画笔、文字、马赛克和本地 OCR。
- 区域录屏：导出 MP4 或 GIF。
- 桌面便签：将卡片向上拖出面板，固定在桌面。
- 本地存储：无需账号，内容保存在自己的 Mac 上。

## 安装与使用

需要 macOS 15 或更新版本。解压安装包后，将 `Pastory.app` 拖入「应用程序」并打开；应用位于菜单栏，点击图标即可显示剪贴板面板。

默认快捷键：⇧⌘V 打开剪贴板、⌥⌘S 截图与录屏、⌥⌘F 搜索。可在设置中修改。

首次截图需授予屏幕录制权限；直接粘贴需要辅助功能权限。签名与公证状态以安装包随附的首次打开说明为准。

## 数据

数据保存在 `~/Library/Application Support/Pastory/`，包含 SQLite 索引与内容文件。Pin 内容不会被自动清理，其他内容按设置中的保留规则处理。没有在线更新检查或剪贴板上传。

## 开发与打包

在 Xcode 中开发时打开 `Pastory.xcodeproj`，选择 `Pastory` scheme 和 `My Mac` 后运行。此工程会生成完整 `.app`，包含应用标识、图标和其他资源。直接打开 `Package.swift` 运行的是 SwiftPM 可执行 target，适合命令行构建，不作为日常 App 调试入口。

```bash
./build.sh                 # 本机架构，输出 build/Pastory.app
./dist.sh                  # Intel + Apple 芯片安装包
./release.sh notes.md      # 准备安装包与发布说明
```

正式签名与公证使用自己的 `SIGN_ID` 和 `NOTARY_PROFILE` 配置。脚本在本地生成产物。

项目仓库：[EEvinci/pastory](https://github.com/EEvinci/pastory)。开发约定见 [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md)。

## 开源许可

许可与第三方组件说明见 [LICENSE](LICENSE) 和 [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md)。
