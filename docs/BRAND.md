# 笺湾 · JotCove

散落的灵感，在这里靠岸。

## 名字

“笺”是文字、截图和随手留下的内容；“湾”是让这些内容停靠、收拢、再次被找到的空间。英文 JotCove 由 jot（随手记下）和 cove（小湾）组合。

中文界面使用“笺湾”，英文界面与应用包使用 JotCove；作者为 Evinci，不使用 Edition 或定制版本副标题。

## 图标

可可棕圆角底座，叠放的米白纸片，收拢纸片的雾霾蓝弧形纸湾，以及一个暖黄圆点。纸片对应复制与收集，弧线对应容纳与归档；大形状保留小尺寸下的识别度。

| 用途 | 文件 |
| --- | --- |
| 生成原稿 | `Resources/Brand/JotCove-icon-master.png` |
| 1024 像素标准图 | `Resources/Brand/JotCove-icon-1024.png` |
| macOS 应用图标 | `Resources/AppIcon.icns`，含标准与 Retina 尺寸 |
| 界面与 README 标识 | `Resources/Logo.png` |
| 菜单栏单色图标 | `Resources/MenuIcon.png`、`MenuIcon@2x.png` |
| 菜单栏图标可重复生成源码 | `scripts/MakeMenuIcon.swift` |

图标原稿使用 imagegen 生成，经机械缩放后组装为 ICNS。菜单栏使用配套的原生绘制单色符号，交给系统适配深浅菜单栏。画布和小尺寸清晰度参考 [Apple App Icons 指南](https://developer.apple.com/design/human-interface-guidelines/app-icons)。

## 升级兼容

新产品名从 v1.2.0 开始使用。源目录、SwiftPM target、Xcode 工程、scheme、应用包和分发文件均使用 JotCove。

应用内部标识 `local.pastory.app`、历史目录 `~/Library/Application Support/Pastory/`、数据库文件 `pastory.sqlite` 保持不变，用于延续已有设置与历史。它们是兼容标识，不是用户界面的品牌名。已有历史内容不作批量替换，避免改写用户保存的文本、标题或链接。

自测环境变量使用 `JOTCOVE_STORE`、`JOTCOVE_LANG`；旧的 `PASTORY_STORE`、`PASTORY_LANG` 仍作为兼容入口，仅在自测时生效。

## 备份

改名前版本固定在 `backup/pre-jotcove-2026-10-26`，首次备份仍在 `backup/pre-style-2026-10-23`。原有发布说明属于历史版本，保留其当时名称。
